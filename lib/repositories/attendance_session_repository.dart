import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/services/attendance_session_service.dart';
import '../models/attendance_session_model.dart';

class AttendanceSessionRepository {
  final AttendanceSessionService service;

  AttendanceSessionRepository({
    required this.service,
  });

  Future<String> createSession({
    required String courseOfferingId,
    required String instructorId,
  }) {
    return service.createSession(
      courseOfferingId: courseOfferingId,
      instructorId: instructorId,
    );
  }

  Future<void> deactivateActiveSessions(
    String courseOfferingId,
  ) {
    return service.deactivateActiveSessions(
      courseOfferingId,
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getActiveSession(
    String courseOfferingId,
  ) {
    return service.getActiveSession(
      courseOfferingId,
    );
  }

  Future<void> refreshSession(
    String sessionId,
  ) {
    return service.refreshSession(
      sessionId,
    );
  }

  Future<void> closeSession(
    String sessionId,
  ) {
    return service.closeSession(
      sessionId,
    );
  }

  Future<List<AttendanceSessionModel>> getCourseSessions(
    String courseOfferingId,
  ) {
    return service.getCourseSessions(
      courseOfferingId,
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getTodaySession(
    String courseOfferingId,
  ) {
    return service.getTodaySession(
      courseOfferingId,
    );
  }
  Future<DocumentSnapshot<Map<String, dynamic>>?>
    getSessionById(
  String sessionId,
) async {
  return await service.getSessionById(
    sessionId,
  );
}
}
