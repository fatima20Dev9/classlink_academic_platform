import 'package:get/get.dart';

import '../models/attendance_record_model.dart';
import '../repositories/attendance_repository.dart';

class AttendanceSessionRecordsController
    extends GetxController {
  final AttendanceRepository _repo =
      Get.find<AttendanceRepository>();

  final RxBool isLoading = false.obs;

  final RxList<AttendanceRecordModel> records =
      <AttendanceRecordModel>[].obs;

  Future<void> loadRecords(
    String sessionId,
  ) async {
    try {
      isLoading.value = true;

      final data =
          await _repo.getSessionRecords(
        sessionId,
      );

      records.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}