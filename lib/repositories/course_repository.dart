import 'package:get/get.dart';
import '../core/services/course_service.dart';

import '../models/course_model.dart';
import '../models/course_details_model.dart';
import 'user_repository.dart';

class CourseRepository {
  final CourseService _service;
  final UserRepository _userRepo = UserRepository();
  CourseRepository({
    CourseService? service,
  }) : _service = service ?? Get.find<CourseService>();

  Future<List<CourseModel>> all() => _service.fetchAllCourses();

  Future<CourseModel?> byId(String id) => _service.fetchById(id);

  Future<List<CourseModel>> getByIds(List<String> ids) =>
      _service.fetchByIds(ids);

  Future<int> nextColor(String uid) => _service.getNextColor(uid);

  Future<String> add(Map<String, dynamic> data) => _service.addCourse(data);

  Future<void> update(String id, Map<String, dynamic> data) =>
      _service.updateCourse(id, data);

  Future<void> delete(String id) => _service.deleteCourse(id);

  // =========================================================
  // 🔥 FIXED: Student + Instructor unified loading
  // =========================================================

  Future<List<CourseDetailsViewModel>> fetchUserCoursesWithOfferings(
    String uid,
  ) async {
    final enrollments = await _service.fetchOfferingsByUser(uid);
print("ENROLLMENTS COUNT = ${enrollments.length}");

    if (enrollments.isEmpty) return [];

    final offeringIds = enrollments.map((e) => e.id).toList();
print("IDS SENT TO OFFERINGS = $offeringIds");

    final offerings = await _service.fetchOfferingsByIds(offeringIds);
print("OFFERINGS FOUND = ${offerings.length}");
    if (offerings.isEmpty) return [];

    final courseIds = offerings.map((e) => e.courseId).toSet().toList();

    final courses = await _service.fetchByIds(courseIds);

    final courseMap = {
      for (final c in courses) c.id: c,
    };

    final List<CourseDetailsViewModel> result = [];

    for (final offering in offerings) {
      final course = courseMap[offering.courseId];

      if (course == null) continue;

      final instructorName = await _userRepo.getUserName(offering.instructorId);

      result.add(
        CourseDetailsViewModel.fromModel(
          course,
          offering,
          instructorName: instructorName,
        ),
      );
    }

    return result;
  }
}
