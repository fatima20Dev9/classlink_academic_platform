import 'dart:async';
import 'package:get/get.dart';

import '../../../models/course_details_model.dart';
import '../../../repositories/course_repository.dart';
import '../../../../features/auth/controllers/session_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../repositories/enrolled_courses_repository.dart';
import '../../../core/services/enrolled_courses_service.dart';

class HomeController extends GetxController {
  final CourseRepository _repository;
  final String role;

  HomeController({
    required this.role,

    CourseRepository? repository
    })
      : _repository = repository ?? CourseRepository();

  final RxBool isLoading = true.obs;
  final RxList<CourseDetailsViewModel> courses =
      <CourseDetailsViewModel>[].obs;

  final RxString errorMessage = ''.obs;

  late final SessionController _session =
      Get.find<SessionController>();

  @override
  void onInit() {
    super.onInit();
      print("HOME CONTROLLER INIT");

    loadCourses();
    
  }

  // Future<void> loadCourses() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     final uid = _session.uid;

  //     if (uid.isEmpty) {
  //       courses.clear();
  //       errorMessage.value = "User not found";
  //       return;
  //     }

  //     final data = await _repository.fetchUserCoursesWithOfferings(uid);

  //     // if (data.isEmpty) {
  //     //   errorMessage.value = "No courses found";
  //     // }

  //     courses.assignAll(data);
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     courses.clear();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
// Future<void> loadCourses


Future<void> loadCourses() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final uid = _session.uid;

    print("UID = $uid");
    print("ROLE = $role");

    if (uid.isEmpty) {
      courses.clear();
      errorMessage.value = "User not found";
      return;
    }

    if (role.toLowerCase() == 'student') {
      final repo = EnrolledCoursesRepository(
        service: EnrolledCoursesService(),
      );

      final data = await repo.getEnrolledCourses(uid);

      print("STUDENT COURSES = ${data.length}");

      courses.assignAll(data);
    } else {
      final data =
          await _repository.fetchUserCoursesWithOfferings(uid);

      print("INSTRUCTOR COURSES = ${data.length}");

      courses.assignAll(data);
    }
  } catch (e, s) {
    print("ERROR = $e");
    print(s);

    errorMessage.value = e.toString();
    courses.clear();
  } finally {
    isLoading.value = false;
  }
}

  Future<void> refreshCourses() async {
    await loadCourses();
  }
}