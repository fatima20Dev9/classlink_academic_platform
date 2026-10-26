import '../core/services/enrolled_courses_service.dart';
import '../models/course_details_model.dart';
import '../models/course_model.dart';
import '../models/course_offering_model.dart';
import '../models/enrollment_model.dart';

class EnrolledCoursesRepository {
  final EnrolledCoursesService _service;

  EnrolledCoursesRepository({
    required EnrolledCoursesService service,
  }) : _service = service;

  Future<List<CourseDetailsViewModel>> getEnrolledCourses(
    String studentId,
  ) async {
    /// 1) Fetch enrollments
    final enrollmentsSnapshot =
        await _service.fetchEnrollments(studentId);

    final enrollments = enrollmentsSnapshot
        .map(
          (doc) => EnrollmentModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();

    if (enrollments.isEmpty) return [];

    /// 2) Extract offering ids
    final offeringIds = enrollments
        .map((e) => e.courseOfferingId)
        .toSet()
        .toList();

    /// 3) Batch fetch offering docs
    final offeringDocs =
        await _service.fetchOfferingsByIds(
      offeringIds,
    );

    final offerings = offeringDocs
        .map(
          (doc) =>
              CourseOfferingModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();

    final offeringMap = {
      for (final offering in offerings)
        offering.id: offering,
    };

    /// 4) Extract course ids
    final courseIds = offerings
        .map((o) => o.courseId)
        .toSet()
        .toList();

    /// 5) Batch fetch course docs
    final courseDocs =
        await _service.fetchCoursesByIds(
      courseIds,
    );

    final courses = courseDocs
        .map(
          (doc) => CourseModel.fromFirestore(
            doc.data(),
            doc.id,
          ),
        )
        .toList();

    final courseMap = {
      for (final course in courses)
        course.id: course,
    };

    /// 6) Extract instructor ids
    final instructorIds = offerings
        .map((o) => o.instructorId)
        .toSet()
        .toList();

    /// 7) Batch fetch user docs
    final userDocs =
        await _service.fetchUsersByIds(
      instructorIds,
    );

    final userMap = {
      for (final doc in userDocs)
        doc.id: doc.data(),
    };

    /// 8) Final join
    final List<CourseDetailsViewModel> result = [];

    for (final enrollment in enrollments) {
      final offering =
          offeringMap[
              enrollment.courseOfferingId];

      if (offering == null) continue;

      final course =
          courseMap[offering.courseId];

      if (course == null) continue;

      final userData =
          userMap[offering.instructorId];

      final instructorName =
          userData?['name'] as String? ?? '';

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