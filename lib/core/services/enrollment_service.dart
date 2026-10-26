import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/enrollment_model.dart';
import '../../repositories/chat_repository.dart';
import 'firebase_service.dart';

class EnrollmentService {
  final FirebaseService _fb = FirebaseService.instance;

  ChatRepository? get _chatRepo {
    if (Get.isRegistered<ChatRepository>()) {
      return Get.find<ChatRepository>();
    }
    return null;
  }

  /// =========================
  /// Get enrollments by student
  /// =========================
  Future<List<EnrollmentModel>> fetchByStudent(String studentId) async {
    final snap = await _fb.enrollments
        .where('studentId', isEqualTo: studentId)
        .orderBy('enrolledAt', descending: true)
        .get();

    return snap.docs
        .map((d) => EnrollmentModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  /// =========================
  /// Get enrollments by offering
  /// =========================
  Future<List<EnrollmentModel>> fetchByOffering(String offeringId) async {
    final snap = await _fb.enrollments
        .where('courseOfferingId', isEqualTo: offeringId)
        .orderBy('enrolledAt', descending: true)
        .get();

    return snap.docs
        .map((d) => EnrollmentModel.fromFirestore(d.data(), d.id))
        .toList();
  }

  /// =========================
  /// Enroll student (prevent duplicates)
  /// =========================
  Future<String> enroll(String studentId, String offeringId) async {
    final existing = await _fb.enrollments
        .where('studentId', isEqualTo: studentId)
        .where('courseOfferingId', isEqualTo: offeringId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      // Even if already enrolled, ensure the chat membership is in sync.
      await _addToGroupChatSafely(offeringId, studentId);
      return existing.docs.first.id;
    }

    final ref = await _fb.enrollments.add({
      'studentId': studentId,
      'courseOfferingId': offeringId,
      'enrolledAt': FieldValue.serverTimestamp(),
    });

    // Keep group chat membership synchronized with enrollment.
    await _addToGroupChatSafely(offeringId, studentId);

    return ref.id;
  }

  Future<void> _addToGroupChatSafely(String offeringId, String userId) async {
    try {
      await _chatRepo?.addMemberToGroupChat(
        courseOfferingId: offeringId,
        userId: userId,
      );
    } catch (_) {
      // never fail enrollment because of chat sync
    }
  }

  /// =========================
  /// Remove enrollment
  /// =========================
  Future<void> remove(String id) async {
    await _fb.enrollments.doc(id).delete();
  }

Future<void> deleteByOffering(String offeringId) async {
  final snapshot = await _fb.enrollments
      .where('courseOfferingId', isEqualTo: offeringId)
      .get();

  final batch = FirebaseFirestore.instance.batch();

  for (final doc in snapshot.docs) {
    batch.delete(doc.reference);
  }

  await batch.commit();
}
  /// =========================
  /// Check enrollment
  /// =========================
  Future<bool> isEnrolled(String studentId, String offeringId) async {
    final snap = await _fb.enrollments
        .where('studentId', isEqualTo: studentId)
        .where('courseOfferingId', isEqualTo: offeringId)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }

  /// =========================
  /// Helper: get offering IDs for student (IMPORTANT)
  /// تستخدم في شاشة الطالب
  /// =========================
  Future<List<String>> getStudentOfferingIds(String studentId) async {
    final snap = await fetchByStudent(studentId);

    return snap.map((e) => e.courseOfferingId).toList();
  }
}
