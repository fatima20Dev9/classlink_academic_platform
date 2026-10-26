import 'dart:async';

import 'package:get/get.dart';

import '../../../repositories/attendance_session_repository.dart';
import '../../auth/controllers/session_controller.dart';

class InstructorQrController extends GetxController {
  final AttendanceSessionRepository _repo =
      Get.find<AttendanceSessionRepository>();

  final SessionController _session =
      Get.find<SessionController>();

  final String courseOfferingId;

  InstructorQrController({
    required this.courseOfferingId,
  });

  final RxBool isLoading = false.obs;
  final RxString qrData = ''.obs;

  Timer? _timer;

  String? currentSessionId;

  @override
  void onInit() {
    super.onInit();

    generateQr();

    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => generateQr(),
    );
  }

  Future<void> generateQr() async {
    try {
      isLoading.value = true;

      final instructorId = _session.uid;

      // ابحث عن جلسة اليوم
      final todaySession =
          await _repo.getTodaySession(
        courseOfferingId,
      );

      if (todaySession == null) {
        // إنشاء جلسة جديدة لأول مرة فقط
        currentSessionId =
            await _repo.createSession(
          courseOfferingId:
              courseOfferingId,
          instructorId:
              instructorId,
        );
      } else {
        // استخدام نفس جلسة اليوم
        currentSessionId =
            todaySession.id;

        // تحديث QR فقط
        await _repo.refreshSession(
          currentSessionId!,
        );
      }

      // جلب الجلسة نفسها مباشرة
      final sessionDoc =
          await _repo.getSessionById(
        currentSessionId!,
      );

      if (sessionDoc == null) return;

      final data = sessionDoc.data();

      if (data == null) return;

      qrData.value =
          '$courseOfferingId|$currentSessionId|${data['sessionKey']}';
    } catch (e) {
      print(
        'QR ERROR => $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}