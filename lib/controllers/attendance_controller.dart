import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../core/utils/base_controller.dart';
import '../models/attendance_model.dart';
import '../repositories/attendance_repository.dart';
import '../features/auth/controllers/session_controller.dart';

class AttendanceController extends BaseController {
  final AttendanceRepository _repo = AttendanceRepository();
  late final SessionController _session = Get.find<SessionController>();

  final RxList<AttendanceModel> records = <AttendanceModel>[].obs;

  Future<List<AttendanceModel>> loadStudentRecords(String courseOffering) async {
    final uid = _session.uid;
    print('currrrent uid = $uid');

    if (uid == null) return [];
    final data = await runGuarded<List<AttendanceModel>>(
      () => _repo.byStudent(studentId: uid, courseOfferingId: courseOffering),
      isEmpty: (l) => l.isEmpty,
    );

      print('RECORDS COUNT = ${data?.length}');

    if (data != null) records.assignAll(data);
    return data ?? [];
  }

  Future<void> mark({
    required String studentId,
    required String courseOfferingId,
    AttendanceStatus status = AttendanceStatus.present,
  }) async {
    await runGuarded(() => _repo.mark({
          'studentId': studentId,
          'courseOfferingId': courseOfferingId,
          'status': status.name,
          'date': Timestamp.now(),
        }));
  }
}
