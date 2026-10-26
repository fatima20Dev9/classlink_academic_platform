import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course_offering_model.dart';
import 'firebase_service.dart';
import '../utils/invite_code_generator.dart';

class CourseOfferingService {
  final FirebaseService _fb = FirebaseService.instance;

  // =========================
  // READ
  // =========================

  Future<List<CourseOfferingModel>> fetchAll() async {
    final snap = await _fb.courseOfferings.get();

    return snap.docs
        .map((doc) => CourseOfferingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<CourseOfferingModel>> fetchByInstructor(
      String instructorId) async {
    final snap = await _fb.courseOfferings
        .where('instructorId', isEqualTo: instructorId)
        .get();

    return snap.docs
        .map((doc) => CourseOfferingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<CourseOfferingModel?> fetchById(String id) async {
    final doc = await _fb.courseOfferings.doc(id).get();

    if (!doc.exists || doc.data() == null) return null;

    return CourseOfferingModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<List<CourseOfferingModel>> fetchByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final chunks = _chunkList(ids, 10);

    final snapshots = await Future.wait(
      chunks.map(
        (chunk) => _fb.courseOfferings
            .where(FieldPath.documentId, whereIn: chunk)
            .get(),
      ),
    );

    final offerings = snapshots
        .expand((snap) => snap.docs)
        .map((doc) => CourseOfferingModel.fromFirestore(doc.data(), doc.id))
        .toList();

    final map = {for (final o in offerings) o.id: o};

    return ids.where(map.containsKey).map((id) => map[id]!).toList();
  }

  Future<CourseOfferingModel?> fetchByInviteCode(String code) async {
    final snap = await _fb.courseOfferings
        .where('inviteCode', isEqualTo: code)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final doc = snap.docs.first;

    return CourseOfferingModel.fromFirestore(doc.data(), doc.id);
  }

  Future<List<CourseOfferingModel>> fetchByCourse(String courseId) async {
    final snap =
        await _fb.courseOfferings.where('courseId', isEqualTo: courseId).get();

    return snap.docs
        .map((doc) => CourseOfferingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<String> generateUniqueInviteCode() async {
  while (true) {
    final code = InviteCodeGenerator.generate();

    final exists = await _fb.courseOfferings
        .where('inviteCode', isEqualTo: code)
        .limit(1)
        .get();

    if (exists.docs.isEmpty) {
      return code;
    }
  }
}

  // =========================
  // Student enrollments flow
  // =========================

  Future<List<CourseOfferingModel>> fetchByUser(String userId) async {
    final enrollmentsSnap =
        await _fb.enrollments.where('studentId', isEqualTo: userId).get();

    if (enrollmentsSnap.docs.isEmpty) return [];

    final offeringIds = enrollmentsSnap.docs
        .map((doc) => doc.data()['courseOfferingId'] as String?)
        .whereType<String>()
        .toList();

    if (offeringIds.isEmpty) return [];

    return fetchByIds(offeringIds);
  }

  // =========================
  // WRITE
  // =========================

  Future<String> add(Map<String, dynamic> data) async {
    final ref = await _fb.courseOfferings.add(data);
    return ref.id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _fb.courseOfferings.doc(id).update(data);
  }

  Future<void> delete(String id) async {
    await _fb.courseOfferings.doc(id).delete();
  }

  // =========================
  // HELPERS
  // =========================

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
