import 'package:cloud_firestore/cloud_firestore.dart';
import 'file_model.dart';

class AssignmentModel {
  final String id;
  final String courseOfferingId;
  final String instructorId;
  final String title;
  final String description;
  final Timestamp dueDate;
  final FileModel? file;
  final double maxGrade;
  final String status;

  AssignmentModel({
    required this.id,
    required this.courseOfferingId,
    required this.instructorId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxGrade,
    required this.status,
    this.file,
  });

  // from Firestore
  factory AssignmentModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return AssignmentModel(
      id: docId,
      courseOfferingId: json['courseOfferingId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? Timestamp.now(),
      maxGrade: _parseDouble(json['maxGrade']),
      status: json['status'] ?? 'draft',
      file: json['file'] != null ? FileModel.fromJson(json['file']) : null,
    );
  }

  // to Firestore
  Map<String, dynamic> toJson() {
    return {
      'courseOfferingId': courseOfferingId,
      'instructorId': instructorId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'maxGrade': maxGrade,
      'status': status,
      'file': file?.toJson(),
    };
  }

  // safe double parsing
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // copyWith (for getx updates)
  // update only specific fields without needing to provide all fields again
  // ssignment.copyWith(status: 'published') updates just the status field
  AssignmentModel copyWith({
    String? id,
    String? courseOfferingId,
    String? instructorId,
    String? title,
    String? description,
    Timestamp? dueDate,
    FileModel? file,
    double? maxGrade,
    String? status,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      instructorId: instructorId ?? this.instructorId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      file: file ?? this.file,
      maxGrade: maxGrade ?? this.maxGrade,
      status: status ?? this.status,
    );
  }

  bool get isClosed {
    final due = dueDate.toDate();

    final today = DateTime.now();

    return DateTime(
      today.year,
      today.month,
      today.day,
    ).isAfter(
      DateTime(
        due.year,
        due.month,
        due.day,
      ),
    );
  }

  bool get isActive => !isClosed;


  String get dueDateText {
  final d = dueDate.toDate();

  return '${d.day}/${d.month}/${d.year}';
}

String get attachmentName {
  return file?.name ?? 'No attachment';
}

String get attachmentSize {
  return file?.formattedSize ?? '';
}
}
