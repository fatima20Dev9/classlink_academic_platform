import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/assignment_model.dart';
import '../../models/wrappers/assignment_with_submission.dart';
import '../../models/submission_model.dart';

class AssignmentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _col => _db.collection('assignments');

  // =========================
  // GET BY COURSE OFFERING
  // =========================
  Future<List<AssignmentModel>> getByCourseOffering(String id) async {
    print("Searching for courseOfferingId = $id");

    final snap = await _col
        .where('courseOfferingId', isEqualTo: id)
        .orderBy('dueDate', descending: true)
        .get();

    print("Documents found = ${snap.docs.length}");

    for (final doc in snap.docs) {
      print(doc.data());
    }

    return snap.docs
        .map((e) => AssignmentModel.fromJson(
              e.data() as Map<String, dynamic>,
              e.id,
            ))
        .toList();
  }

  // =========================
  // ADD ASSIGNMENT
  // =========================
  Future<String> add(Map<String, dynamic> data) async {
    final doc = await _col.add(data);
    return doc.id;
  }

  // =========================
  // UPLOAD FILE
  // =========================
  Future<String> uploadFile(File file, String name) async {
    final ref = _storage
        .ref()
        .child('assignments')
        .child(DateTime.now().millisecondsSinceEpoch.toString() + '_$name');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> delete(String assignmentId) async {
    await _col.doc(assignmentId).delete();
  }

  Future<void> update(
    String assignmentId,
    Map<String, dynamic> data,
  ) async {
    await _col.doc(assignmentId).update(data);
  }

// student flow ===========================
  Future<List<AssignmentWithSubmission>> getStudentAssignments({
    required String courseOfferingId,
    required String studentId,
  }) async {
    // 1️⃣ Get assignments
    final snap = await _col
        .where('courseOfferingId', isEqualTo: courseOfferingId)
        .orderBy('dueDate', descending: true)
        .get();

    final assignments = snap.docs.map((e) {
      return AssignmentModel.fromJson(
        e.data() as Map<String, dynamic>,
        e.id,
      );
    }).toList();

    // 2️⃣ Get submissions of this student
    final submissionSnap = await _db
        .collection('submissions')
        .where('studentId', isEqualTo: studentId)
        .get();

    final submissions = submissionSnap.docs.map((e) {
      return SubmissionModel.fromJson(e.data(), e.id);
    }).toList();

    // 3️⃣ Map submissions by assignmentId
    final submissionMap = {for (var s in submissions) s.assignmentId: s};

    // 4️⃣ Merge
    return assignments.map((assignment) {
      return AssignmentWithSubmission(
        assignment: assignment,
        submission: submissionMap[assignment.id],
      );
    }).toList();
  }
}
