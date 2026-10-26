import 'package:get/get.dart';

import '../../models/app_notification_model.dart';
import '../../repositories/course_offering_repository.dart';
import '../../repositories/course_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/notification_repository.dart';

/// Resolves recipients + course name and writes a notification.
///
/// This is the single entry point that all features (assignments,
/// lectures, chat) call when an event happens. It keeps each feature
/// controller free from Firestore-specific notification logic.
class NotificationDispatcher {
  final NotificationRepository _notifications;
  final EnrollmentRepository _enrollments;
  final CourseOfferingRepository _offerings;
  final CourseRepository _courses;

  NotificationDispatcher({
    NotificationRepository? notifications,
    EnrollmentRepository? enrollments,
    CourseOfferingRepository? offerings,
    CourseRepository? courses,
  })  : _notifications =
            notifications ?? Get.find<NotificationRepository>(),
        _enrollments = enrollments ?? Get.find<EnrollmentRepository>(),
        _offerings = offerings ?? Get.find<CourseOfferingRepository>(),
        _courses = courses ?? Get.find<CourseRepository>();

  /// Resolve the course display name + the instructor uid for an offering.
  Future<({String courseName, String instructorId})> _resolveCourse(
    String courseOfferingId,
  ) async {
    try {
      final offerings =
          await _offerings.getByIds([courseOfferingId]);
      if (offerings.isEmpty) {
        return (courseName: '', instructorId: '');
      }
      final offering = offerings.first;
      final course = await _courses.byId(offering.courseId);
      return (
        courseName: course?.name ?? '',
        instructorId: offering.instructorId,
      );
    } catch (_) {
      return (courseName: '', instructorId: '');
    }
  }

  /// All student uids enrolled in [courseOfferingId].
  Future<List<String>> _studentsOf(String courseOfferingId) async {
    try {
      final enrollments =
          await _enrollments.byOffering(courseOfferingId);
      return enrollments.map((e) => e.studentId).toSet().toList();
    } catch (_) {
      return [];
    }
  }

  /// Fire-and-forget: never throws — failures are swallowed so the
  /// main user action (create assignment / send message …) succeeds.
  Future<void> _safeCreate({
    required String title,
    required String message,
    required String type,
    required String courseOfferingId,
    required String courseName,
    required List<String> recipients,
    Map<String, dynamic> data = const {},
  }) async {
    if (recipients.isEmpty) return;
    try {
      await _notifications.create(
        title: title,
        message: message,
        type: type,
        courseOfferingId: courseOfferingId,
        courseName: courseName,
        recipients: recipients,
        data: data,
      );
    } catch (e) {
      // ignore: avoid_print
      print('NotificationDispatcher error: $e');
    }
  }

  /// New assignment created by an instructor.
  Future<void> assignmentCreated({
    required String courseOfferingId,
    required String assignmentId,
    required String title,
    String description = '',
    String? excludeUid,
  }) async {
    final ctx = await _resolveCourse(courseOfferingId);
    final students = await _studentsOf(courseOfferingId);
    final recipients = students
        .where((uid) => excludeUid == null || uid != excludeUid)
        .toList();

    await _safeCreate(
      title: 'New assignment: $title',
      message: description.isEmpty
          ? 'A new assignment has been posted.'
          : description,
      type: NotificationTypes.assignment,
      courseOfferingId: courseOfferingId,
      courseName: ctx.courseName,
      recipients: recipients,
      data: {'assignmentId': assignmentId},
    );
  }

  /// New lecture material uploaded.
  Future<void> lectureUploaded({
    required String courseOfferingId,
    required String lectureId,
    required String fileName,
    String? excludeUid,
  }) async {
    final ctx = await _resolveCourse(courseOfferingId);
    final students = await _studentsOf(courseOfferingId);
    final recipients = students
        .where((uid) => excludeUid == null || uid != excludeUid)
        .toList();

    await _safeCreate(
      title: 'New lecture material',
      message: fileName.isEmpty
          ? 'A new lecture file was uploaded.'
          : fileName,
      type: NotificationTypes.lecture,
      courseOfferingId: courseOfferingId,
      courseName: ctx.courseName,
      recipients: recipients,
      data: {'lectureId': lectureId},
    );
  }

  /// New chat message — notifies the *other* participants only.
  Future<void> chatMessageSent({
    required String chatId,
    required String senderId,
    required String senderName,
    required List<String> participants,
    required String preview,
    String courseOfferingId = '',
  }) async {
    final recipients =
        participants.where((id) => id != senderId).toList();
    if (recipients.isEmpty) return;

    String courseName = '';
    if (courseOfferingId.isNotEmpty) {
      final ctx = await _resolveCourse(courseOfferingId);
      courseName = ctx.courseName;
    }

    await _safeCreate(
      title: senderName.isEmpty ? 'New message' : 'Message from $senderName',
      message: preview,
      type: NotificationTypes.chat,
      courseOfferingId: courseOfferingId,
      courseName: courseName,
      recipients: recipients,
      data: {'chatId': chatId, 'senderId': senderId},
    );
  }
}
