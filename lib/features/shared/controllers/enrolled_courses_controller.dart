import 'package:get/get.dart';

import '../../../models/course_details_model.dart';
import '../../../repositories/course_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../repositories/course_offering_repository.dart';
import '../../../repositories/enrollment_repository.dart';
import '/features/auth/controllers/session_controller.dart';

class EnrolledCoursesController extends GetxController {
  final EnrollmentRepository _enrollmentRepo;
  final CourseRepository _courseRepo;
  final CourseOfferingRepository _offeringRepo;
  final UserRepository _userRepo;

  EnrolledCoursesController({
    EnrollmentRepository? enrollmentRepo,
    CourseRepository? courseRepo,
    CourseOfferingRepository? offeringRepo,
    UserRepository? userRepo,
  })  : _enrollmentRepo = enrollmentRepo ?? EnrollmentRepository(),
        _courseRepo = courseRepo ?? CourseRepository(),
        _offeringRepo = offeringRepo ?? CourseOfferingRepository(),
        _userRepo = userRepo ?? UserRepository();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<CourseDetailsViewModel> courses = <CourseDetailsViewModel>[].obs;

  final SessionController _session = Get.find<SessionController>();

  RxString get errorMessage => error;
  bool get hasError => error.value.isNotEmpty;
  bool get isEmpty => courses.isEmpty && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    print(
      "CONTROLLER HASH = ${hashCode}",
    );

    fetchCourses();
  }

  Future<void> fetchCourses() async {
    print("FETCH COURSES START");
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _session.uid;

      print("USER ID = $userId");
      print("IS INSTRUCTOR = ${_session.isInstructor}");

      if (userId.isEmpty) {
        courses.clear();
        return;
      }

      /// 🔥 INSTRUCTOR
      if (_session.isInstructor) {
        final result = await _courseRepo.fetchUserCoursesWithOfferings(userId);

        courses.assignAll(result);
        return;
      }

      /// 🔥 STUDENT
     
     print("STEP 1");

      final enrollments = await _enrollmentRepo.byStudent(userId);
print("STEP 2 ${enrollments.length}");

      if (enrollments.isEmpty) {
        courses.clear();
        return;
      }

      final offeringIds = enrollments.map((e) => e.courseOfferingId).toList();
print("STEP 3");

      final offerings = await _offeringRepo.getByIds(offeringIds);
print("STEP 4 ${offerings.length}");

      final courseIds = offerings.map((o) => o.courseId).toList();
print("STEP 5");

      final courseList = await _courseRepo.getByIds(courseIds);
      print("STEP 6 ${courseList.length}");

print("STEP 7");
      final offeringMap = {
        for (final o in offerings) o.id: o,
      };

      final courseMap = {
        for (final c in courseList) c.id: c,
      };

      final result = <CourseDetailsViewModel>[];

      for (final e in enrollments) {
        final offering = offeringMap[e.courseOfferingId];
        if (offering == null) continue;

        final course = courseMap[offering.courseId];
        if (course == null) continue;

        final instructorName =
            await _userRepo.getUserName(offering.instructorId);

        result.add(
          CourseDetailsViewModel.fromModel(
            course,
            offering,
            instructorName: instructorName,
          ),
        );
      }
      print(
        "ENROLLED PAGE RESULT = ${result.length}",
      );
      courses.assignAll(result);
      print(
        "ENROLLED PAGE ASSIGNED = ${courses.length}",
      );
      print(
        "AFTER ASSIGN = ${courses.length}",
      );
    } catch (e, s) {
  print("ERROR = $e");
  print(s);

  error.value = e.toString();
  courses.clear();
} finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCourses() async {
    await fetchCourses();
  }
}
