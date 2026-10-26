import 'package:get/get.dart';

import '../models/attendance_session_model.dart';
import '../repositories/attendance_session_repository.dart';
import '../models/attendance_record_model.dart';
import '../repositories/attendance_repository.dart';

class AttendanceSessionsController extends GetxController {
  final AttendanceSessionRepository _repo =
      Get.find<AttendanceSessionRepository>();

  final RxBool isLoading = false.obs;

  final RxList<AttendanceSessionModel> sessions =
      <AttendanceSessionModel>[].obs;

  Future<void> loadSessions(
    String courseOfferingId,
  ) async {
    print('session COURSE ID = $courseOfferingId');

    try {
      isLoading.value = true;

      final data = await _repo.getCourseSessions(
        courseOfferingId,
      );

      print('SESSIONS COUNT = ${data.length}');

      sessions.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  final RxMap<String, List<AttendanceRecordModel>> sessionRecords =
      <String, List<AttendanceRecordModel>>{}.obs;

  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();

  Future<void> loadSessionRecords(
    String sessionId,
  ) async {
    if (sessionRecords.containsKey(sessionId)) {
      return;
    }

    final data = await _attendanceRepo.getSessionRecords(
      sessionId,
    );

    sessionRecords[sessionId] = data;
  }
}
