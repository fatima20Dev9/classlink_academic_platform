import 'package:cloud_firestore/cloud_firestore.dart';
import 'file_model.dart';

class LectureModel {
  final String id;
  final String courseOfferingId;
  final FileModel file;
  final Timestamp createdAt;

  LectureModel({
    required this.id,
    required this.courseOfferingId,
    required this.file,
    required this.createdAt,
  });

  // from Firestore
  factory LectureModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return LectureModel(
      id: docId,
      courseOfferingId: json['courseOfferingId'] ?? '',
      file: FileModel.fromJson(json['file'] ?? {}),
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  // to Firestore
  Map<String, dynamic> toJson() {
    return {
      'courseOfferingId': courseOfferingId,
      'file': file.toJson(),
      'createdAt': createdAt,
    };
  }

  // copyWith
  LectureModel copyWith({
    String? id,
    String? courseOfferingId,
    FileModel? file,
    Timestamp? createdAt,
  }) {
    return LectureModel(
      id: id ?? this.id,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      file: file ?? this.file,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}