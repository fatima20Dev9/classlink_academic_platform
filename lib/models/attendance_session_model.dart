import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceSessionModel {
  final String id;
  final String courseOfferingId;
  final String instructorId;
  final String sessionKey;
  final int lectureNumber;
  final Timestamp createdAt;
  final Timestamp expiresAt;
  final bool isActive;

  AttendanceSessionModel({
    required this.id,
    required this.courseOfferingId,
    required this.instructorId,
    required this.sessionKey,
    required this.lectureNumber,
    required this.createdAt,
    required this.expiresAt,
    required this.isActive,
  });

  factory AttendanceSessionModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return AttendanceSessionModel(
      id: docId,
      courseOfferingId: json['courseOfferingId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      sessionKey: json['sessionKey'] ?? '',
      lectureNumber: json['lectureNumber'] ?? 0,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      expiresAt: json['expiresAt'] ?? Timestamp.now(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseOfferingId': courseOfferingId,
      'instructorId': instructorId,
      'sessionKey': sessionKey,
      'lectureNumber': lectureNumber,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'isActive': isActive,
    };
  }
}
