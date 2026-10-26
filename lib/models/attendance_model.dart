import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, late }

class AttendanceModel {
  final String id;
  final String studentId;
  final String courseOfferingId;
  final String? lectureId;
  final AttendanceStatus status;
  final Timestamp date;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.courseOfferingId,
    required this.status,
    required this.date,
    this.lectureId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json, String docId) {
    return AttendanceModel(
      id: docId,
      studentId: json['studentId'] ?? '',
      courseOfferingId: json['courseOfferingId'] ?? '',
      lectureId: json['lectureId'],
      status: _parseStatus(json['status']),
      date: json['attendedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseOfferingId': courseOfferingId,
      'lectureId': lectureId,
      'status': status.name,
      'date': date,
    };
  }

  static AttendanceStatus _parseStatus(dynamic v) {
    if (v == 'absent') return AttendanceStatus.absent;
    if (v == 'late') return AttendanceStatus.late;
    return AttendanceStatus.present;
  }

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? courseOfferingId,
    String? lectureId,
    AttendanceStatus? status,
    Timestamp? date,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      lectureId: lectureId ?? this.lectureId,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
