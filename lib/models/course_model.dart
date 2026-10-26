import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String name;
  final String overview;
  final int credits;

  /// 🔥 instructor / owner
  final String userId;

  /// 🔥 UI color
  final int color;

  /// 🔥 created time
  final Timestamp createdAt;

  CourseModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.credits,
    required this.userId,
    required this.color,
    required this.createdAt,
  });

  // =========================
  // FIRESTORE -> MODEL
  // =========================
  factory CourseModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return CourseModel(
      id: docId,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      credits: _parseInt(json['credits']),

      userId: json['userId'] ?? '',

      color: _parseInt(json['color']),

      createdAt: _parseTimestamp(json['createdAt']),
    );
  }

  factory CourseModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) =>
      CourseModel.fromJson(json, docId);

  // =========================
  // MODEL -> FIRESTORE
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'overview': overview,
      'credits': credits,
      'userId': userId,
      'color': color,
      'createdAt': createdAt,
    };
  }

  // =========================
  // HELPERS
  // =========================
  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);
    return Timestamp.now();
  }

  // =========================
  // COPY WITH
  // =========================
  CourseModel copyWith({
    String? id,
    String? name,
    String? overview,
    int? credits,
    String? userId,
    int? color,
    Timestamp? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      credits: credits ?? this.credits,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}