import '../core/services/course_offering_service.dart';
import '../models/course_offering_model.dart';
import '../repositories/enrollment_repository.dart';

class CourseOfferingRepository {
  final CourseOfferingService _service;
  final EnrollmentRepository _enrollmentRepo = EnrollmentRepository();

  CourseOfferingRepository({
    CourseOfferingService? service,
  }) : _service = service ?? CourseOfferingService();

  // =========================
  // READ OPERATIONS
  // =========================

  Future<List<CourseOfferingModel>> all() => _service.fetchAll();

  Future<CourseOfferingModel?> byId(String id) => _service.fetchById(id);

  Future<List<CourseOfferingModel>> byInstructor(String instructorId) =>
      _service.fetchByInstructor(instructorId);

  Future<List<CourseOfferingModel>> byCourse(String courseId) =>
      _service.fetchByCourse(courseId);

  Future<List<CourseOfferingModel>> byUser(String userId) =>
      _service.fetchByUser(userId);

  Future<CourseOfferingModel?> byInviteCode(String code) =>
      _service.fetchByInviteCode(code);

  Future<List<CourseOfferingModel>> getByIds(List<String> ids) =>
      _service.fetchByIds(ids);

  // =========================
  // WRITE OPERATIONS
  // =========================

  Future<String> add(Map<String, dynamic> data) => _service.add(data);

  Future<void> update(String id, Map<String, dynamic> data) =>
      _service.update(id, data);

  Future<void> delete(String id) => _service.delete(id);

  Future<String> generateUniqueInviteCode() {
    return _service.generateUniqueInviteCode();
  }
  // =========================
  // BUSINESS LOGIC (IMPORTANT)
  // =========================

  // =========================
  // CREATE OFFERING
  // =========================
  Future<String> createOffering({
    required String courseId,
    required String instructorId,
  }) async {
    final inviteCode = await _service.generateUniqueInviteCode();

    return _service.add({
      'courseId': courseId,
      'instructorId': instructorId,
      'inviteCode': inviteCode,
      'createdAt': DateTime.now(),
    });
  }

  // =========================
  // JOIN BY CODE (NO FIRESTORE HERE)
  // =========================
  Future<CourseOfferingModel?> getByInviteCode(String code) {
    return _service.fetchByInviteCode(code);
  }
// =========================
  // JOIN COURSE (CORRECT VERSION)
  // =========================

  Future<bool> joinByInviteCode({
    required String studentId,
    required String inviteCode,
  }) async {
    final offering = await _service.fetchByInviteCode(inviteCode.trim());

    if (offering == null) return false;

    try {
      await _enrollmentRepo.enroll(studentId, offering.id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
