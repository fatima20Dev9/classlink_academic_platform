import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course_model.dart';
import '../../models/course_offering_model.dart';
import '../utils/app_colors.dart';
import 'firebase_service.dart';

class CourseService {
  final FirebaseService _fb = FirebaseService.instance;

  // =========================
  // COURSES
  // =========================

  Future<List<CourseModel>> fetchAllCourses() async {
    final snap = await _fb.courses.get();

    return snap.docs
        .map((d) => CourseModel.fromJson(d.data(), d.id))
        .toList();
  }

  Future<List<CourseModel>> fetchUserCourses(String uid) async {
    final snap = await _fb.courses
        .where('userId', isEqualTo: uid)
        .get();

    return snap.docs
        .map((d) => CourseModel.fromJson(d.data(), d.id))
        .toList();
  }

  Stream<List<CourseModel>> userCoursesStream(String uid) {
    return _fb.courses
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => CourseModel.fromJson(d.data(), d.id))
              .toList(),
        );
  }

  Future<CourseModel?> fetchById(String id) async {
    final doc = await _fb.courses.doc(id).get();

    if (!doc.exists) return null;

    return CourseModel.fromJson(doc.data()!, doc.id);
  }

  Future<List<CourseModel>> fetchByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final chunks = _chunkList(ids, 10);

    final snapshots = await Future.wait(
      chunks.map(
        (chunk) => _fb.courses
            .where(FieldPath.documentId, whereIn: chunk)
            .get(),
      ),
    );

    return snapshots
        .expand((s) => s.docs)
        .map((d) => CourseModel.fromJson(d.data(), d.id))
        .toList();
  }

  // =========================
  // COURSES WRITE
  // =========================

  Future<String> addCourse(Map<String, dynamic> data) async {
    final ref = await _fb.courses.add(data);
    return ref.id;
  }

  Future<void> updateCourse(
    String id,
    Map<String, dynamic> data,
  ) async {
    await _fb.courses.doc(id).update(data);
  }

  Future<void> deleteCourse(String id) async {
    await _fb.courses.doc(id).delete();
  }

  // =========================
  // COLORS
  // =========================

  Future<int> getNextColor(String uid) async {
    final ref = _fb.users.doc(uid);
    final doc = await ref.get();

    int index = 0;

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['colorIndex'] != null) {
        index = data['colorIndex'] as int;
      }
    }

    final color =
        AppColors.courseColors[index % AppColors.courseColors.length];

    await ref.set(
      {
        'colorIndex': (index + 1) % AppColors.courseColors.length,
      },
      SetOptions(merge: true),
    );

    return color;
  }

  // =========================
  // OFFERINGS
  // =========================

  Future<CourseOfferingModel?> fetchActiveOffering(
    String courseId,
  ) async {
    final snapshot = await _fb.courseOfferings
        .where('courseId', isEqualTo: courseId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;

    return CourseOfferingModel.fromFirestore(
      doc.data(),
      doc.id,
    );
  }

  /// 🔥 FIXED: instructorId بدل userId
  Future<List<CourseOfferingModel>> fetchOfferingsByUser(
    String uid,
  ) async {
    final snapshot = await _fb.courseOfferings
        .where('instructorId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map(
          (d) => CourseOfferingModel.fromFirestore(
            d.data(),
            d.id,
          ),
        )
        .toList();
  }

  Future<List<CourseOfferingModel>> fetchOfferingsByIds(
    List<String> ids,
  ) async {
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
        .map(
          (d) => CourseOfferingModel.fromFirestore(
            d.data(),
            d.id,
          ),
        )
        .toList();

    final map = {
      for (final item in offerings) item.id: item,
    };

    return ids.where(map.containsKey).map((id) => map[id]!).toList();
  }

  // =========================
  // Helpers
  // =========================

  List<List<T>> _chunkList<T>(
    List<T> list,
    int size,
  ) {
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