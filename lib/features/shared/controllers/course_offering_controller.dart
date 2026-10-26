import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/base_controller.dart';
import '../../auth/controllers/session_controller.dart';
import '../controllers/enrolled_courses_controller.dart';
import '../../../core/utils/invite_code_generator.dart';
import '../../../core/utils/load_status.dart';

import '../controllers/home_controller.dart';

import '../../../models/course_offering_model.dart';
import '../../../models/course_details_model.dart';

import '../../../repositories/course_offering_repository.dart';
import '../../../repositories/enrollment_repository.dart';
import '../../../repositories/course_repository.dart';

class CourseOfferingController extends BaseController {
  final CourseOfferingRepository _repo = CourseOfferingRepository();
  final EnrollmentRepository _enrollmentRepo = EnrollmentRepository();
  final CourseRepository _courseRepo = CourseRepository();

  late final SessionController _session;

  /// 🔥 بدل offering فقط → ViewModel كامل
  final RxList<CourseDetailsViewModel> offerings =
      <CourseDetailsViewModel>[].obs;

  final Rx<CourseOfferingModel?> selectedOffering =
      Rx<CourseOfferingModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _session = Get.find<SessionController>();
  }

  // =========================
  // INSTRUCTOR OFFERINGS
  // =========================

  Future<List<CourseDetailsViewModel>> loadInstructorOfferings() async {
    final uid = _session.uid;

    if (uid.isEmpty) {
      offerings.clear();
      return [];
    }

    final data = await runGuarded<List<CourseDetailsViewModel>>(
      () async {
        final courseOfferings = await _repo.byInstructor(uid);
        final courses = await _courseRepo.all();

        final courseMap = {
          for (final c in courses) c.id: c,
        };

        return courseOfferings
            .where((o) => courseMap.containsKey(o.courseId))
            .map(
              (o) => CourseDetailsViewModel.fromModel(
                courseMap[o.courseId]!,
                o,
                instructorName: o.instructorName,
              ),
            )
            .toList();
      },
    );

    if (data != null) {
      offerings.assignAll(data);
    }

    return data ?? [];
  }

  // =========================
  // STUDENT OFFERINGS (FIXED)
  // =========================

  Future<List<CourseDetailsViewModel>> loadUserOfferings() async {
    print("loadUserOfferings CALLED");

    final uid = _session.uid;

    if (uid.isEmpty) {
      offerings.clear();
      return [];
    }

    final data = await runGuarded<List<CourseDetailsViewModel>>(
      () async {
        final enrollments = await _enrollmentRepo.byStudent(uid);

        if (enrollments.isEmpty) return [];

        final offeringIds = enrollments.map((e) => e.courseOfferingId).toList();

        final courseOfferings = await _repo.getByIds(offeringIds);

        final courseIds =
            courseOfferings.map((e) => e.courseId).toSet().toList();

        final courses = await _courseRepo.getByIds(courseIds);

        final courseMap = {
          for (final c in courses) c.id: c,
        };

        return courseOfferings
            .where((o) => courseMap.containsKey(o.courseId))
            .map(
              (o) => CourseDetailsViewModel.fromModel(
                courseMap[o.courseId]!,
                o,
                instructorName: o.instructorName,
              ),
            )
            .toList();
      },
    );

    if (data != null) {
      offerings.assignAll(data);
    }

    return data ?? [];
  }

  Future<String> generateUniqueInviteCode() async {
    while (true) {
      final code = InviteCodeGenerator.generate();

      final exists = await FirebaseFirestore.instance
          .collection('course_offerings')
          .where('inviteCode', isEqualTo: code)
          .limit(1)
          .get();

      if (exists.docs.isEmpty) {
        return code;
      }
    }
  }
  // =========================
  // JOIN COURSE
  // =========================

  Future<bool> joinByInviteCode(String code) async {
    final uid = _session.uid;
    if (uid.isEmpty) return false;

    final result = await runGuarded<bool>(
      () => _repo.joinByInviteCode(
        studentId: uid,
        inviteCode: code.trim(),
      ),
    );

    if (result != true) return false;

    // 🔥 أهم سطر في المشروع
    await Get.find<HomeController>().loadCourses();

    return true;
  }
  // =========================
  // LEAVE COURSE
  // =========================

  Future<void> leaveOffering(String offeringId) async {
    final uid = _session.uid;
    if (uid.isEmpty) return;

    final enrollments = await _enrollmentRepo.byStudent(uid);

    final enrollment = enrollments.firstWhereOrNull(
      (e) => e.courseOfferingId == offeringId,
    );

    if (enrollment == null) return;

    await runGuarded(
      () => _enrollmentRepo.remove(enrollment.id),
    );

    await loadUserOfferings();
  }

Future<void> deleteOffering(String offeringId) async {
  try {
status.value = LoadStatus.loading;

    // 1. حذف enrollments
    await _enrollmentRepo.deleteByOffering(offeringId);

    // 2. حذف offering نفسه
    await _repo.delete(offeringId);

    // 3. تحديث قائمة المعلم
    await loadInstructorOfferings();

    // 4. تحديث قائمة الطالب (Home)
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().loadCourses();
    }

if (Get.isRegistered<EnrolledCoursesController>()) {
  await Get.find<EnrolledCoursesController>().refreshCourses();
} 

    Get.snackbar(
      'Success',
      'Course deleted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar(
      'Error',
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    status.value = LoadStatus.idle;
  }
}
}
