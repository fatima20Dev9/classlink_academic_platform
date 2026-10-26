import 'package:flutter/material.dart';

import 'course_model.dart';
import 'course_offering_model.dart';

class CourseDetailsViewModel {
  /// Core course data
  final CourseModel course;

  /// Specific semester offering
  final CourseOfferingModel offering;

  /// Display data
  final String instructorName;

  const CourseDetailsViewModel({
    required this.course,
    required this.offering,
    required this.instructorName,
  });

  /// =========================
  /// Factory constructor
  /// =========================
  factory CourseDetailsViewModel.fromModel(
    CourseModel course,
    CourseOfferingModel offering, {
    String instructorName = '',
  }) {
    return CourseDetailsViewModel(
      course: course,
      offering: offering,
      instructorName: instructorName,
    );
  }

  // =========================
  // COURSE GETTERS
  // =========================

  String get courseId => course.id;
  String get courseName => course.name;

  /// 🔥 FIXED: was description → now uses overview in CourseModel
  String get overview => course.overview;

  int get credits => course.credits;

  // =========================
  // OFFERING GETTERS
  // =========================

  String get offeringId => offering.id;
  String get instructorId => offering.instructorId;
  String get semester => offering.semester;
  String get dayTime => offering.dayTime;
  String get inviteCode => offering.inviteCode;
  int get progress => offering.progress;

  int get lectures => offering.lectures;
  int get hoursPerWeek => offering.hoursPerWeek;
  int get attendance => offering.attendance;
  int get assignments => offering.assignments;
  int get midterm => offering.midterm;

  DateTime get createdAt {
    try {
      return offering.createdAt.toDate();
    } catch (_) {
      return DateTime.now();
    }
  }

  // =========================
  // UI HELPERS
  // =========================

  Color get color {
    try {
      return Color(course.color);
    } catch (_) {
      return Colors.grey;
    }
  }

  String get fullSemester => offering.semester;
  String get schedule => offering.dayTime;

  bool get hasProgress => progress > 0;
  double get progressValue => (progress.clamp(0, 100)) / 100;

  // =========================
  // COPY WITH
  // =========================

  CourseDetailsViewModel copyWith({
    CourseModel? course,
    CourseOfferingModel? offering,
    String? instructorName,
  }) {
    return CourseDetailsViewModel(
      course: course ?? this.course,
      offering: offering ?? this.offering,
      instructorName: instructorName ?? this.instructorName,
    );
  }
}