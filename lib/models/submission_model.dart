import 'package:cloud_firestore/cloud_firestore.dart';
import 'file_model.dart';
import 'users_model.dart';

enum SubmissionStatus {
  pending,
  handedIn,
  marked,
}

class SubmissionModel {
  final String id;
  final String assignmentId;
  final String studentId; 
  final UserModel? student; // 👈 فقط للعرض (NOT FIRESTORE)
  final FileModel? file;
  final double? grade;
  final SubmissionStatus submissionStatus;
  final Timestamp submittedAt;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.student,
    this.grade,
    required this.submissionStatus,
    required this.submittedAt,
    this.file,
  });

  factory SubmissionModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return SubmissionModel(
      id: docId,
      assignmentId: json['assignmentId'] ?? '',
      studentId: json['studentId'] ?? '',

      file: json['file'] != null && json['file'] is Map
          ? FileModel.fromJson(json['file'])
          : null,

      grade: _parseDoubleOrNull(json['grade']),

      submissionStatus: SubmissionStatus.values.byName(
        json['submissionStatus'] ?? 'pending',
      ),

      submittedAt: json['submittedAt'] is Timestamp
          ? json['submittedAt']
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'studentId': studentId,
      'file': file?.toJson(),
      'grade': grade,
      'submissionStatus': submissionStatus.name,
      'submittedAt': submittedAt,
    };
  }

  static double? _parseDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  SubmissionModel copyWith({
    String? id,
    String? assignmentId,
    String? studentId,
    UserModel? student,
    FileModel? file,
    double? grade,
    SubmissionStatus? submissionStatus,
    Timestamp? submittedAt,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      student: student ?? this.student,
      file: file ?? this.file,
      grade: grade ?? this.grade,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  /// 👇 مهم جداً: ربط المستخدم بعد التحميل
  SubmissionModel copyWithUser(UserModel user) {
    return SubmissionModel(
      id: id,
      assignmentId: assignmentId,
      studentId: studentId,
      student: user,
      file: file,
      grade: grade,
      submissionStatus: submissionStatus,
      submittedAt: submittedAt,
    );
  }
}