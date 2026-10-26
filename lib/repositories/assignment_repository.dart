import 'package:get/get.dart';
import '../core/services/assignment_service.dart';
import '../models/assignment_model.dart';
import '../models/wrappers/assignment_with_submission.dart';
import 'dart:io';

class AssignmentRepository {
  final AssignmentService _service;

  AssignmentRepository({
    AssignmentService? service,
  }) : _service = service ?? Get.find<AssignmentService>();

  Future<List<AssignmentModel>> getByCourseOffering(String id) {
    return _service.getByCourseOffering(id);
  }

  Future<String> add(Map<String, dynamic> data) {
    return _service.add(data);
  }

  Future<String> uploadFile(File file, String name) {
    return _service.uploadFile(file, name);
  }

  Future<void> delete(String assignmentId) {
    return _service.delete(assignmentId);
  }

  Future<void> update(
    String assignmentId,
    Map<String, dynamic> data,
  ) {
    return _service.update(assignmentId, data);
  }

  Future<List<AssignmentWithSubmission>> getStudentAssignments({
    required String courseOfferingId,
    required String studentId,
  }) {
    return _service.getStudentAssignments(
      courseOfferingId: courseOfferingId,
      studentId: studentId,
    );
  }
}
