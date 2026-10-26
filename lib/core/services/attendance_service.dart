import '../../models/attendance_model.dart';
import 'firebase_service.dart';

class AttendanceService {
  final FirebaseService _fb = FirebaseService.instance;

  Future<List<AttendanceModel>> fetchByStudent(String studentId) async {
    final snap = await _fb.attendance
        .where('studentId', isEqualTo: studentId)
        .get();
    return snap.docs
        .map((d) => AttendanceModel.fromJson(d.data(), d.id))
        .toList();
  }

  Future<List<AttendanceModel>> fetchByOffering(String offeringId) async {
    final snap = await _fb.attendance
        .where('courseOfferingId', isEqualTo: offeringId)
        .get();
    return snap.docs
        .map((d) => AttendanceModel.fromJson(d.data(), d.id))
        .toList();
  }

  Future<String> mark(Map<String, dynamic> data) async {
    final ref = await _fb.attendance.add(data);
    return ref.id;
  }
}
