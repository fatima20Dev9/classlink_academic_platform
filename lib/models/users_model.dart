import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, instructor}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final int level;
  final String majorId;
  final String specialization;
  final Timestamp createdAt;
  final bool profileCompleted;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.level,
    required this.majorId,
    required this.specialization,
    required this.createdAt,
    required this.profileCompleted,
    required this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: _roleFromString(json['role'] ?? 'student'),
      level: (json['level'] ?? 0),
      majorId: json['majorId'] ?? '',
      specialization: json['specialization'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      profileCompleted: json['profileCompleted'] ?? false,
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'level': level,
      'majorId': majorId,
      'specialization': specialization,
      'createdAt': createdAt,
      'profileCompleted': profileCompleted,
      'photoUrl': photoUrl,
    };
  }

  static UserRole _roleFromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.student,
    );
  }

  bool get isStudent => role == UserRole.student;
  bool get isInstructor => role == UserRole.instructor;
}
