import 'package:cloud_firestore/cloud_firestore.dart';

class CourseOfferingModel {
  final String id;
  final String courseId;

  final String instructorId;
  final String instructorName;

  final String semester;
  final String dayTime;

  final String inviteCode;

  final int lectures;
  final int hoursPerWeek;

  final int attendance;
  final int assignments;
  final int midterm;

  final int progress;

  final Timestamp createdAt;

  CourseOfferingModel({
    required this.id,
    required this.courseId,
    required this.instructorId,
    required this.instructorName,
    required this.semester,
    required this.dayTime,
    required this.inviteCode,
    required this.lectures,
    required this.hoursPerWeek,
    required this.attendance,
    required this.assignments,
    required this.midterm,
    required this.progress,
    required this.createdAt,
  });

  // =========================
  // FROM FIRESTORE
  // =========================
  factory CourseOfferingModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return CourseOfferingModel(
      id: docId,
      courseId: json['courseId'] ?? '',

      instructorId: json['instructorId'] ?? '',
      instructorName: json['instructorName'] ?? '',

      semester: json['semester'] ?? '',
      dayTime: json['dayTime'] ?? '',

      inviteCode: json['inviteCode'] ?? '',

      lectures: _parseInt(json['lectures']),
      hoursPerWeek: _parseInt(json['hoursPerWeek']),

      attendance: _parseInt(json['attendance']),
      assignments: _parseInt(json['assignments']),
      midterm: _parseInt(json['midterm']),

      progress: _parseInt(json['progress']),

      createdAt: _parseTimestamp(json['createdAt']),
    );
  }

  // =========================
  // TO FIRESTORE
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'instructorId': instructorId,
      'instructorName': instructorName,

      'semester': semester,
      'dayTime': dayTime,

      'inviteCode': inviteCode,

      'lectures': lectures,
      'hoursPerWeek': hoursPerWeek,

      'attendance': attendance,
      'assignments': assignments,
      'midterm': midterm,

      'progress': progress,
      'createdAt': createdAt,
    };
  }

  // =========================
  // SAFE PARSING
  // =========================
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);
    return Timestamp.now();
  }

  // =========================
  // COPY WITH
  // =========================
  CourseOfferingModel copyWith({
    String? id,
    String? courseId,
    String? instructorId,
    String? instructorName,
    String? semester,
    String? dayTime,
    String? inviteCode,
    int? lectures,
    int? hoursPerWeek,
    int? attendance,
    int? assignments,
    int? midterm,
    int? progress,
    Timestamp? createdAt,
  }) {
    return CourseOfferingModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      semester: semester ?? this.semester,
      dayTime: dayTime ?? this.dayTime,
      inviteCode: inviteCode ?? this.inviteCode,
      lectures: lectures ?? this.lectures,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      attendance: attendance ?? this.attendance,
      assignments: assignments ?? this.assignments,
      midterm: midterm ?? this.midterm,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}