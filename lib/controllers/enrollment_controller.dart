import 'package:get/get.dart';

import '../models/enrollment_model.dart';
import '../repositories/enrollment_repository.dart';

class EnrollmentController extends GetxController {
  final EnrollmentRepository _repo =
      Get.find<EnrollmentRepository>();

  final RxList<EnrollmentModel> studentEnrollments =
      <EnrollmentModel>[].obs;

  final RxList<EnrollmentModel> offeringEnrollments =
      <EnrollmentModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // =========================
  // LOAD BY STUDENT
  // =========================
  Future<void> loadByStudent(String studentId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.byStudent(studentId);

      studentEnrollments.assignAll(data);
    } catch (e) {
      error.value = e.toString();
      studentEnrollments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOAD BY OFFERING
  // =========================
  Future<void> loadByOffering(String offeringId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.byOffering(offeringId);

      offeringEnrollments.assignAll(data);
    } catch (e) {
      error.value = e.toString();
      offeringEnrollments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // ENROLL STUDENT
  // =========================
  Future<void> enrollStudent({
    required String studentId,
    required String offeringId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repo.enroll(studentId, offeringId);

      await loadByStudent(studentId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // REMOVE ENROLLMENT
  // =========================
  Future<void> removeEnrollment({
    required String enrollmentId,
    required String studentId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repo.remove(enrollmentId);

      await Future.wait([
        loadByStudent(studentId),
        loadByOffering(enrollmentId), // optional sync
      ]);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // CHECK ENROLLMENT
  // =========================
  bool isStudentEnrolled(String offeringId) {
    return studentEnrollments.any(
      (e) => e.courseOfferingId == offeringId,
    );
  }

  // =========================
  // GET IDS
  // =========================
  List<String> get enrolledOfferingIds {
    return studentEnrollments
        .map((e) => e.courseOfferingId)
        .toList();
  }
}