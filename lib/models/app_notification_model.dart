import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification types emitted by the app.
class NotificationTypes {
  static const String assignment = 'assignment';
  static const String lecture = 'lecture';
  static const String chat = 'chat';
  static const String announcement = 'announcement';
  static const String exam = 'exam';
  static const String general = 'general';
}

class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String courseOfferingId;
  final String courseName;
  final List<String> recipients;
  final List<String> readBy;
  final Map<String, dynamic> data;
  final Timestamp createdAt;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.courseOfferingId,
    required this.createdAt,
    this.courseName = '',
    this.recipients = const [],
    this.readBy = const [],
    this.data = const {},
  });

  /// True if this notification was already read by [uid].
  bool isReadBy(String uid) => readBy.contains(uid);

  factory AppNotificationModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return AppNotificationModel(
      id: docId,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? NotificationTypes.general,
      courseOfferingId: json['courseOfferingId'] ?? '',
      courseName: json['courseName'] ?? '',
      recipients: List<String>.from(json['recipients'] ?? const []),
      readBy: List<String>.from(json['readBy'] ?? const []),
      data: Map<String, dynamic>.from(json['data'] ?? const {}),
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'courseOfferingId': courseOfferingId,
      'courseName': courseName,
      'recipients': recipients,
      'readBy': readBy,
      'data': data,
      'createdAt': createdAt,
    };
  }

  AppNotificationModel copyWith({
    String? title,
    String? message,
    String? type,
    String? courseOfferingId,
    String? courseName,
    List<String>? recipients,
    List<String>? readBy,
    Map<String, dynamic>? data,
    Timestamp? createdAt,
  }) {
    return AppNotificationModel(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      courseName: courseName ?? this.courseName,
      recipients: recipients ?? this.recipients,
      readBy: readBy ?? this.readBy,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
