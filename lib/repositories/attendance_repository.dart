import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';
import '../models/attendance_record_model.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> hasAttendance({
    required String sessionId,
    required String studentId,
  }) async {
    final result = await _firestore
        .collection(
          'attendance_records',
        )
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .where(
          'studentId',
          isEqualTo: studentId,
        )
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<void> markAttendance({
    required String studentId,
    required String courseOfferingId,
    required String sessionId,
  }) async {
    final userDoc = await _firestore.collection('users').doc(studentId).get();

    final studentName = userDoc.data()?['name'] ?? 'Unknown Student';

    final docId = '${sessionId}_$studentId';

    await _firestore.collection('attendance_records').doc(docId).set({
      'studentId': studentId,
      'studentName': studentName,
      'courseOfferingId': courseOfferingId,
      'sessionId': sessionId,
      'attendedAt': Timestamp.now(),
      'status': 'present',
    });
  }

  Future<bool> markAttendanceIfNotExists({
    required String studentId,
    required String courseOfferingId,
    required String sessionId,
  }) async {
    final docId = '${sessionId}_$studentId';

    final doc =
        await _firestore.collection('attendance_records').doc(docId).get();

    if (doc.exists) {
      return false;
    }

    await markAttendance(
      studentId: studentId,
      courseOfferingId: courseOfferingId,
      sessionId: sessionId,
    );

    return true;
  }

  Future<List<AttendanceModel>> byStudent({
    required String studentId,
    required String courseOfferingId,
  }) async {
    final result = await _firestore
        .collection('attendance_records')
        .where(
          'studentId',
          isEqualTo: studentId,
        )
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        // .orderBy(
        //   'attendedAt',
        //   descending: true,
        // )
        .get();

    return result.docs.map((doc) {
      return AttendanceModel.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  }
// Future<List<AttendanceModel>> byStudent(
//   String studentId,

// ) async {

//   final result = await _firestore
//       .collection('attendance_records')
//       .where(
//         'studentId',
//         isEqualTo: studentId,
//       )
//       .orderBy('attendedAt', descending: true)
//       .get();

//   return result.docs.map((doc) {
//     return AttendanceModel.fromJson(
//       doc.data(),
//       doc.id,
//     );
//   }).toList();
// }

  Future<void> mark(Map<String, dynamic> data) async {
    final sessionId = data['sessionId'];
    final studentId = data['studentId'];

    final docId = '${sessionId}_$studentId';

    await _firestore.collection('attendance_records').doc(docId).set({
      ...data,
      'attendedAt': Timestamp.now(),
    });
  }

// display students attendance records
  Future<List<AttendanceRecordModel>> getSessionRecords(
    String sessionId,
  ) async {
    final result = await _firestore
        .collection('attendance_records')
        .where(
          'sessionId',
          isEqualTo: sessionId,
        )
        .orderBy('attendedAt')
        .get();

    return result.docs
        .map(
          (e) => AttendanceRecordModel.fromJson(
            e.data(),
            e.id,
          ),
        )
        .toList();
  }
}
