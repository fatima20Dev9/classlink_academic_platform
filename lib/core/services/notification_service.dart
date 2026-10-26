import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('notifications');

  /// Create a notification document.
  Future<String> create(Map<String, dynamic> data) async {
    final doc = await _col.add(data);
    return doc.id;
  }

  /// Real-time stream of notifications addressed to [uid], newest first.
  Stream<QuerySnapshot<Map<String, dynamic>>> streamForUser(
    String uid, {
    int? limit,
  }) {
    Query<Map<String, dynamic>> q = _col
        .where('recipients', arrayContains: uid)
        .orderBy('createdAt', descending: true);

    if (limit != null) q = q.limit(limit);
    return q.snapshots();
  }

  /// One-shot fetch of notifications addressed to [uid], newest first.
  Future<QuerySnapshot<Map<String, dynamic>>> fetchForUser(
    String uid, {
    int? limit,
  }) {
    Query<Map<String, dynamic>> q = _col
        .where('recipients', arrayContains: uid)
        .orderBy('createdAt', descending: true);

    if (limit != null) q = q.limit(limit);
    return q.get();
  }

  /// Mark [notificationId] as read by [uid] (adds to the readBy array).
  Future<void> markAsRead(String notificationId, String uid) async {
    await _col.doc(notificationId).update({
      'readBy': FieldValue.arrayUnion([uid]),
    });
  }

  /// Legacy: kept for backward compatibility with old callers.
  Future<QuerySnapshot<Map<String, dynamic>>> fetchByCourseOfferings(
    List<String> courseOfferingIds,
  ) {
    return _col
        .where('courseOfferingId', whereIn: courseOfferingIds)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
  }
}
