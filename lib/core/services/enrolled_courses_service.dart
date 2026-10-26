
// "Aggregation / Data Composition Service"
// هذا السيرفس مسؤول عن تجميع البيانات من مصادر مختلفة (الكورسات، العروض، المستخدمين) وتقديمها بشكل جاهز للاستخدام في الواجهة

import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledCoursesService {
  final FirebaseFirestore _firestore;

  EnrolledCoursesService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// =========================
  /// ENROLLMENTS (طالب)
  /// =========================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchEnrollments(
    String studentId,
  ) async {
    final snap = await _firestore
        .collection('enrollments')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snap.docs;
  }

  /// =========================
  /// FETCH SINGLE DOCUMENTS
  /// =========================

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchOffering(
    String offeringId,
  ) {
    return _firestore
        .collection('courseOfferings') // ⚠️ مهم: بدون underscore
        .doc(offeringId)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchCourse(
    String courseId,
  ) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUser(
    String userId,
  ) {
    return _firestore
        .collection('users') // ⚠️ كان غلط: user → الصحيح users
        .doc(userId)
        .get();
  }

  /// =========================
  /// GET OFFERINGS BY IDS
  /// =========================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchOfferingsByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final chunks = _chunkList(ids, 10);
    final result = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection('courseOfferings')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      result.addAll(snapshot.docs);
    }

    return result;
  }

  /// =========================
  /// GET COURSES BY IDS
  /// =========================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchCoursesByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final chunks = _chunkList(ids, 10);
    final result = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection('courses')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      result.addAll(snapshot.docs);
    }

    return result;
  }

  /// =========================
  /// GET USERS BY IDS
  /// =========================
  
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchUsersByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final chunks = _chunkList(ids, 10);
    final result = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      result.addAll(snapshot.docs);
    }

    return result;
  }

  /// =========================
  /// HELPER
  /// =========================
  List<List<T>> _chunkList<T>(List<T> list, int size) {
    final chunks = <List<T>>[];

    for (var i = 0; i < list.length; i += size) {
      chunks.add(
        list.sublist(
          i,
          i + size > list.length ? list.length : i + size,
        ),
      );
    }

    return chunks;
  }
}