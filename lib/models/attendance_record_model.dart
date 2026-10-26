import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecordModel {
  final String id;

  final String studentId;
  final String? studentName;

  final String courseOfferingId;

  final String sessionId;

  final Timestamp attendedAt;

  final String status;

  AttendanceRecordModel({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.courseOfferingId,
    required this.sessionId,
    required this.attendedAt,
    required this.status,
  });

  factory AttendanceRecordModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return AttendanceRecordModel(
      id: docId,
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'],
      courseOfferingId: json['courseOfferingId'] ?? '',
      sessionId: json['sessionId'] ?? '',
      attendedAt: json['attendedAt'] ?? Timestamp.now(),
      status: json['status'] ?? 'present',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'courseOfferingId': courseOfferingId,
      'sessionId': sessionId,
      'attendedAt': attendedAt,
      'status': status,
    };
  }
}
