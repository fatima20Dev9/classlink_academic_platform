import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/base_controller.dart';
import '../features/auth/controllers/session_controller.dart';

import '../models/course_model.dart';
import '../models/course_offering_model.dart';
import '../models/course_details_model.dart';
import '../repositories/course_repository.dart';

class CourseController extends BaseController {
  final CourseRepository _repo = CourseRepository();

  late final SessionController _session;

  final RxList<CourseDetailsViewModel> courses =
      <CourseDetailsViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _session = Get.find<SessionController>();
    loadUserCourses();
  }

  // =========================
  // LOAD USER COURSES (FIXED)
  // =========================

  Future<List<CourseDetailsViewModel>> loadUserCourses() async {
    final uid = _session.uid;

    if (uid == null) {
      courses.clear();
      return [];
    }

    final data = await runGuarded<List<CourseDetailsViewModel>>(
      () => _repo.fetchUserCoursesWithOfferings(uid),
      isEmpty: (list) => list.isEmpty,
    );

    if (data != null) {
      courses.assignAll(data);
    }

    return data ?? [];
  }

  // =========================
  // ADD COURSE (INSTRUCTOR ONLY)
  // =========================

  Future<void> addCourse({
    required String name,
    required String description,
    required int credits,
  }) async {
    final uid = _session.uid;
    if (uid == null) return;

    final color = await _repo.nextColor(uid);

    await runGuarded(
      () => _repo.add({
        'userId': uid,
        'name': name.trim(),
        'description': description.trim(),
        'credits': credits,
        'color': color,
        'createdAt': Timestamp.now(),
      }),
    );

    await loadUserCourses();
  }

  // =========================
  // DELETE COURSE
  // =========================

  Future<void> deleteCourse(String id) async {
    await runGuarded(() => _repo.delete(id));
    await loadUserCourses();
  }

  // =========================
  // UPDATE COURSE
  // =========================

  Future<void> updateCourse({
    required String id,
    required String name,
    required String description,
    required int credits,
  }) async {
    await runGuarded(
      () => _repo.update(
        id,
        {
          'name': name.trim(),
          'description': description.trim(),
          'credits': credits,
        },
      ),
    );

    await loadUserCourses();
  }

  // =========================
  // UI COLOR
  // =========================

  int get nextPaletteColor {
    final index = courses.length % AppColors.courseColors.length;
    return AppColors.courseColors[index];
  }
}
