import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/services/notification_service.dart';
import '../models/app_notification_model.dart';

class NotificationRepository {
  final NotificationService _service;

  NotificationRepository({NotificationService? service})
      : _service = service ?? NotificationService();

  /// Real-time stream of notifications for a user.
  Stream<List<AppNotificationModel>> streamForUser(
    String uid, {
    int? limit,
  }) {
    return _service.streamForUser(uid, limit: limit).map(
          (snap) => snap.docs
              .map(
                (d) => AppNotificationModel.fromJson(d.data(), d.id),
              )
              .toList(),
        );
  }

  /// One-shot fetch.
  Future<List<AppNotificationModel>> fetchForUser(
    String uid, {
    int? limit,
  }) async {
    final snap = await _service.fetchForUser(uid, limit: limit);
    return snap.docs
        .map((d) => AppNotificationModel.fromJson(d.data(), d.id))
        .toList();
  }

  Future<void> markAsRead(String notificationId, String uid) {
    return _service.markAsRead(notificationId, uid);
  }

  /// Create a notification. [recipients] must NOT be empty.
  Future<String> create({
    required String title,
    required String message,
    required String type,
    required String courseOfferingId,
    required String courseName,
    required List<String> recipients,
    Map<String, dynamic> data = const {},
  }) {
    if (recipients.isEmpty) {
      return Future.value('');
    }
    return _service.create({
      'title': title,
      'message': message,
      'type': type,
      'courseOfferingId': courseOfferingId,
      'courseName': courseName,
      'recipients': recipients,
      'readBy': <String>[],
      'data': data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Legacy fallback (kept for backward compatibility).
  Future<List<AppNotificationModel>> getNotificationsForCourses(
    List<String> courseOfferingIds,
  ) async {
    if (courseOfferingIds.isEmpty) return [];
    final snap = await _service.fetchByCourseOfferings(courseOfferingIds);
    return snap.docs
        .map((d) => AppNotificationModel.fromJson(d.data(), d.id))
        .toList();
  }
}
