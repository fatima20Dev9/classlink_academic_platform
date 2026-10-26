import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/submission_model.dart';
import '../models/users_model.dart';

class SubmissionRepository {
  final FirebaseFirestore _firestore;

  SubmissionRepository(this._firestore);

  /// ================= STREAM: ALL SUBMISSIONS FOR ASSIGNMENT =================
  Stream<List<SubmissionModel>> getSubmissionsByAssignment(String assignmentId) {
    return _firestore
        .collection('submissions')
        .where('assignmentId', isEqualTo: assignmentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SubmissionModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  /// ================= STUDENT: GET MY SUBMISSION =================
  Stream<List<SubmissionModel>> getStudentSubmissions(String studentId) {
    return _firestore
        .collection('submissions')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SubmissionModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
Future<UserModel> getUserById(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  return UserModel.fromJson(doc.data()!);
}
  /// ================= STUDENT: CREATE SUBMISSION =================
  Future<void> submitAssignment({
    required String assignmentId,
    required String studentId,
    required Map<String, dynamic>? file,
  }) async {
    await _firestore.collection('submissions').add({
      'assignmentId': assignmentId,
      'studentId': studentId,
      'file': file,
      'grade': null,
      'submissionStatus': 'handedIn',
      'submittedAt': Timestamp.now(),
    });
  }

  /// ================= STUDENT: UPDATE SUBMISSION =================
  Future<void> updateSubmission({
    required String submissionId,
    Map<String, dynamic>? file,
  }) async {
    await _firestore
        .collection('submissions')
        .doc(submissionId)
        .update({
      if (file != null) 'file': file,
      'submissionStatus': 'handedIn',
      'submittedAt': Timestamp.now(),
    });
  }

  /// ================= STUDENT: DELETE SUBMISSION =================
  Future<void> deleteSubmission(String submissionId) async {
    await _firestore.collection('submissions').doc(submissionId).delete();
  }

  /// ================= INSTRUCTOR: GRADE SUBMISSION =================
  Future<void> gradeSubmission({
    required String submissionId,
    required double grade,
  }) async {
    await _firestore.collection('submissions').doc(submissionId).update({
      'grade': grade,
      'submissionStatus': 'marked',
    });
  }

  /// ================= INSTRUCTOR: CHANGE STATUS =================
  Future<void> updateStatus({
    required String submissionId,
    required String status, // pending / handedIn / marked
  }) async {
    await _firestore.collection('submissions').doc(submissionId).update({
      'submissionStatus': status,
    });
  }
}