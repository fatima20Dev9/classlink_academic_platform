import '../core/services/enrollment_service.dart';
import '../models/enrollment_model.dart';

class EnrollmentRepository {
  final EnrollmentService _service;

  EnrollmentRepository({
    EnrollmentService? service,
  }) : _service = service ?? EnrollmentService();

  Future<List<EnrollmentModel>> byStudent(
    String studentId,
  ) {
    return _service.fetchByStudent(
      studentId,
    );
  }

  Future<List<EnrollmentModel>> byOffering(
    String offeringId,
  ) {
    return _service.fetchByOffering(
      offeringId,
    );
  }

  Future<String> enroll(
    String studentId,
    String offeringId,
  ) {
    return _service.enroll(
      studentId,
      offeringId,
    );
  }

  Future<void> remove(String id) {
    return _service.remove(id);
  }
  
  Future<void> deleteByOffering(String offeringId) {
  return _service.deleteByOffering(offeringId);
}
}
