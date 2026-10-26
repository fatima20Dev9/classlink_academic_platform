import 'package:get/get.dart';

import '../core/services/lecture_service.dart';
import '../models/lecture_model.dart';

class LectureRepository {
  final LectureService _service;

  LectureRepository({
    LectureService? service,
  }) : _service = service ?? Get.find<LectureService>();

  // ================================
  // GET LECTURES
  // ================================
  Future<List<LectureModel>> getByCourseOffering(
    String courseOfferingId,
  ) {
    return _service.getByCourseOffering(courseOfferingId);
  }

  // ================================
  // ADD LECTURE (Firestore)
  // ================================
  Future<String> addLecture(Map<String, dynamic> data) {
    return _service.addLecture(data);
  }

  // ================================
  // UPLOAD FILE (Firebase Storage)
  // ================================
  Future<String> uploadFile(String path) {
    return _service.uploadFile(path);
  }
}
