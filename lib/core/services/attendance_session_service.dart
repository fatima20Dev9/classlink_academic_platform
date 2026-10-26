import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/attendance_session_model.dart';

class AttendanceSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sessions =>
      _firestore.collection(
        'attendance_sessions',
      );

  CollectionReference<Map<String, dynamic>> get _offerings =>
      _firestore.collection('course_offerings');

  String generateSessionKey() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    final random = Random();

    return List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<String> createSession({
    required String courseOfferingId,
    required String instructorId,
  }) async {
    await deactivateActiveSessions(
      courseOfferingId,
    );

    final previousSessions = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .get();

    final lectureNumber = previousSessions.docs.length + 1;

    final sessionKey = generateSessionKey();

    final now = DateTime.now();

    final expiresAt = now.add(
      const Duration(
        seconds: 30,
      ),
    );

    final doc = await _sessions.add({
      'courseOfferingId': courseOfferingId,
      'instructorId': instructorId,
      'sessionKey': sessionKey,
      'lectureNumber': lectureNumber,
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isActive': true,
    });

    // Auto-update course offering progress after a new attendance
    // session is created. Progress = completedSessions / totalLectures.
    await _recalculateOfferingProgress(
      courseOfferingId: courseOfferingId,
      completedSessions: lectureNumber,
    );

    return doc.id;
  }

  /// Recalculates and persists the course offering progress.
  /// Total lecture count is the fixed `lectures` field on the offering.
  Future<void> _recalculateOfferingProgress({
    required String courseOfferingId,
    required int completedSessions,
  }) async {
    try {
      final offeringDoc = await _offerings.doc(courseOfferingId).get();
      if (!offeringDoc.exists) return;

      final data = offeringDoc.data();
      final totalLectures = (data?['lectures'] as num?)?.toInt() ?? 0;
      if (totalLectures <= 0) return;

      final raw = (completedSessions / totalLectures) * 100;
      final progress = raw.clamp(0, 100).round();

      await _offerings.doc(courseOfferingId).update({
        'progress': progress,
      });
    } catch (_) {
      // never fail the session creation because of progress sync
    }
  }

  /// Public re-sync helper (can be called from anywhere if needed).
  Future<void> syncOfferingProgress(String courseOfferingId) async {
    final snap = await _sessions
        .where('courseOfferingId', isEqualTo: courseOfferingId)
        .get();
    await _recalculateOfferingProgress(
      courseOfferingId: courseOfferingId,
      completedSessions: snap.docs.length,
    );
  }

  Future<void> deactivateActiveSessions(
    String courseOfferingId,
  ) async {
    final query = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .where(
          'isActive',
          isEqualTo: true,
        )
        .get();

    for (final doc in query.docs) {
      await doc.reference.update({
        'isActive': false,
      });
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getActiveSession(
    String courseOfferingId,
  ) async {
    final query = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .where(
          'isActive',
          isEqualTo: true,
        )
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first;
  }

  // student find valid session
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findValidSession({
    required String courseOfferingId,
    required String sessionKey,
  }) async {
    final query = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .where(
          'sessionKey',
          isEqualTo: sessionKey,
        )
        .where(
          'isActive',
          isEqualTo: true,
        )
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }

    final doc = query.docs.first;

    final expiresAt = (doc['expiresAt'] as Timestamp).toDate();

    if (DateTime.now().isAfter(
      expiresAt,
    )) {
      return null;
    }

    return doc;
  }

  Future<void> refreshSession(
    String sessionId,
  ) async {
    final newKey = generateSessionKey();

    final expiresAt = DateTime.now().add(
      const Duration(seconds: 30),
    );

    await _sessions.doc(sessionId).update({
      'sessionKey': newKey,
      'expiresAt': Timestamp.fromDate(
        expiresAt,
      ),
    });
  }

  Future<void> closeSession(
    String sessionId,
  ) async {
    await _sessions.doc(sessionId).update({
      'isActive': false,
    });
  }

  Future<List<AttendanceSessionModel>> getCourseSessions(
    String courseOfferingId,
  ) async {
    final result = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .orderBy(
          'lectureNumber',
          descending: true,
        )
        .get();

    return result.docs
        .map(
          (e) => AttendanceSessionModel.fromJson(
            e.data(),
            e.id,
          ),
        )
        .toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getTodaySession(
    String courseOfferingId,
  ) async {
    final now = DateTime.now();

    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );

    final query = await _sessions
        .where(
          'courseOfferingId',
          isEqualTo: courseOfferingId,
        )
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
        )
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getSessionById(
    String sessionId,
  ) async {
    final doc = await _sessions.doc(sessionId).get();

    if (!doc.exists) {
      return null;
    }

    return doc;
  }
}
