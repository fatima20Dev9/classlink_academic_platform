import 'package:get/get.dart';

import '../../../repositories/course_repository.dart';
import '../../../repositories/assignment_repository.dart';
import '../../auth/controllers/session_controller.dart';
import '../../../repositories/enrolled_courses_repository.dart';
import '../../../models/assignment_model.dart';
import '../../../models/wrappers/assignment_with_submission.dart';

class AllAssignmentsController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();

  final AssignmentRepository _assignmentRepo = Get.find<AssignmentRepository>();

  final SessionController _session = Get.find<SessionController>();

  final RxBool isLoading = false.obs;

  final RxString search = ''.obs;

  /// =========================
  /// Instructor
  /// =========================

  final RxList<AssignmentModel> instructorAssignments = <AssignmentModel>[].obs;

  /// =========================
  /// Student
  /// =========================

  final RxList<AssignmentWithSubmission> studentAssignments =
      <AssignmentWithSubmission>[].obs;

  /// =========================
  /// Instructor Load
  /// =========================

  Future<void> loadInstructorAssignments() async {
    try {
      isLoading.value = true;

      final uid = _session.uid;

      if (uid.isEmpty) {
        instructorAssignments.clear();
        return;
      }

      final courses = await _courseRepo.fetchUserCoursesWithOfferings(
        uid,
      );

      final List<AssignmentModel> allAssignments = [];

      for (final course in courses) {
        final result = await _assignmentRepo.getByCourseOffering(
          course.offering.id,
        );

        allAssignments.addAll(result);
      }

      allAssignments.sort(
        (a, b) => a.dueDate.compareTo(b.dueDate),
      );

      instructorAssignments.assignAll(
        allAssignments,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// Student Load
  /// =========================

  Future<void> loadStudentAssignments() async {
    try {
      isLoading.value = true;

      final uid = _session.uid;

      if (uid.isEmpty) {
        studentAssignments.clear();
        return;
      }

final EnrolledCoursesRepository _enrolledRepo =
    Get.find<EnrolledCoursesRepository>();

print('2USER ID = $uid');

      // final courses = await _courseRepo.fetchUserCoursesWithOfferings(
      //   uid,
      // );

      final courses =
    await _enrolledRepo.getEnrolledCourses(uid);

print('COURSES COUNT = ${courses.length}');

      final List<AssignmentWithSubmission> allAssignments = [];

      for (final course in courses) {

        print(
    'COURSE = ${course.course.name}'
  );
        final result = await _assignmentRepo.getStudentAssignments(
          courseOfferingId: course.offering.id,
          studentId: uid,
        );
print(
    'ASSIGNMENTS = ${result.length}'
  );

        allAssignments.addAll(result);
      }

      allAssignments.sort(
        (a, b) => a.assignment.dueDate.compareTo(
          b.assignment.dueDate,
        ),
      );

print(
  'TOTAL STUDENT ASSIGNMENTS = ${allAssignments.length}',
);
      studentAssignments.assignAll(
        allAssignments,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// Search
  /// =========================

  void updateSearch(String value) {
    search.value = value;
  }

  /// =========================
  /// Instructor Filtered
  /// =========================

  List<AssignmentModel> get filteredInstructorAssignments {
    final q = search.value.trim().toLowerCase();

    if (q.isEmpty) {
      return instructorAssignments;
    }

    return instructorAssignments.where((e) {
      return e.title.toLowerCase().contains(q);
    }).toList();
  }

  /// =========================
  /// Student Filtered
  /// =========================

  List<AssignmentWithSubmission> get filteredStudentAssignments {
    final q = search.value.trim().toLowerCase();

    if (q.isEmpty) {
      return studentAssignments;
    }

    return studentAssignments.where((e) {
      return e.assignment.title.toLowerCase().contains(q);
    }).toList();
  }
}
