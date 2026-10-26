import 'package:classlink_academic_platform/core/services/people_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// =========================
/// CONTROLLERS
/// =========================
import '../features/instructor/controllers/assignment_controller.dart';
import '../features/student/controllers/assignment_controller.dart';
import '../features/shared/controllers/all_assignments_controller.dart';
import '../features/instructor/controllers/submission_controller.dart';
import '../controllers/attendance_controller.dart';
import '../features/shared/controllers/chat_controller.dart';
import '../controllers/course_controller.dart';
import '../features/shared/controllers/course_offering_controller.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/controllers/session_controller.dart';

import '../features/shared/controllers/people_controller.dart';
import '../features/shared/controllers/enrolled_courses_controller.dart';
import '../features/shared/controllers/lectures_controller.dart';
import '../features/shared/controllers/home_controller.dart';
import '../features/shared/controllers/notification_controller.dart';
import '../core/services/notification_dispatcher.dart';

/// =========================
/// REPOSITORIES
/// =========================
import '../repositories/assignment_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/submission_repository.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/course_repository.dart';
import '../repositories/course_offering_repository.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/lecture_repository.dart';
import '../repositories/enrolled_courses_repository.dart';
import '../repositories/attendance_session_repository.dart';

/// =========================
/// SERVICES
/// =========================
import '../core/services/assignment_service.dart';
import '../core/services/submission_service.dart';
import '../core/services/attendance_service.dart';
import '../core/services/chat_service.dart';
import '../core/services/course_service.dart';
import '../core/services/course_offering_service.dart';
import '../core/services/enrollment_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/lecture_service.dart';
import '../core/services/enrolled_courses_service.dart';
import '../core/services/attendance_session_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    /// =========================================================
    /// CORE / GLOBAL CONTROLLERS
    /// =========================================================

    Get.put<SessionController>(
      SessionController(),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(),
      permanent: true,
    );

    /// =========================================================
    /// SERVICES
    /// =========================================================

    Get.lazyPut<EnrollmentService>(
      () => EnrollmentService(),
      fenix: true,
    );

    Get.lazyPut<CourseService>(
      () => CourseService(),
      fenix: true,
    );

    Get.lazyPut<CourseOfferingService>(
      () => CourseOfferingService(),
      fenix: true,
    );

    Get.lazyPut<AssignmentService>(
      () => AssignmentService(),
      fenix: true,
    );

    Get.lazyPut<SubmissionService>(
      () => SubmissionService(),
      fenix: true,
    );

    Get.lazyPut<AttendanceService>(
      () => AttendanceService(),
      fenix: true,
    );

    Get.lazyPut<NotificationService>(
      () => NotificationService(),
      fenix: true,
    );

    Get.lazyPut<LectureService>(() => LectureService());

    Get.lazyPut<EnrolledCoursesService>(
      () => EnrolledCoursesService(),
      fenix: true,
    );

    Get.lazyPut<AttendanceSessionService>(
      () => AttendanceSessionService(),
      fenix: true,
    );

    Get.lazyPut<ChatService>(
      () => ChatService(),
      fenix: true,
    );

    Get.lazyPut<PeopleService>(
      () => PeopleService(),
      fenix: true,
    );

    /// =========================================================
    /// REPOSITORIES
    /// =========================================================

    Get.lazyPut<EnrollmentRepository>(
      () => EnrollmentRepository(
        service: Get.find<EnrollmentService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CourseRepository>(
      () => CourseRepository(
        service: Get.find<CourseService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CourseOfferingRepository>(
      () => CourseOfferingRepository(
        service: Get.find<CourseOfferingService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AssignmentRepository>(
      () => AssignmentRepository(
        service: Get.find<AssignmentService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SubmissionRepository>(
      () => SubmissionRepository(
        // Get.find<FirebaseFirestore>(),
        FirebaseFirestore.instance,
      ),
      fenix: true,
    );

    Get.lazyPut<UserRepository>(
      () => UserRepository(),
      fenix: true,
    );

    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepository(),
      fenix: true,
    );

    Get.lazyPut<ChatRepository>(
      () => ChatRepository(),
      fenix: true,
    );

    Get.lazyPut<NotificationRepository>(
      () => NotificationRepository(
        service: Get.find<NotificationService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<NotificationDispatcher>(
      () => NotificationDispatcher(),
      fenix: true,
    );

    // Eagerly create the notification controller so the bell badge
    // and home section get the realtime stream immediately after login.
    Get.put<NotificationController>(
      NotificationController(),
      permanent: true,
    );


    Get.lazyPut<LectureRepository>(() => LectureRepository());

    Get.lazyPut<EnrolledCoursesRepository>(
      () => EnrolledCoursesRepository(
        service: Get.find<EnrolledCoursesService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AttendanceSessionRepository>(
      () => AttendanceSessionRepository(
        service: Get.find<AttendanceSessionService>(),
      ),
      fenix: true,
    );

    /// =========================================================
    /// CONTROLLERS
    /// =========================================================

    Get.lazyPut<CourseController>(
      () => CourseController(),
      fenix: true,
    );

    Get.lazyPut<CourseOfferingController>(
      () => CourseOfferingController(),
      fenix: true,
    );

    Get.lazyPut<EnrolledCoursesController>(
      () => EnrolledCoursesController(
        enrollmentRepo: Get.find<EnrollmentRepository>(),
        courseRepo: Get.find<CourseRepository>(),
        offeringRepo: Get.find<CourseOfferingRepository>(),
      ),
      fenix: true,
    );
    // Get.lazyPut<HomeController>(
    //   () => HomeController(
    //     repository: Get.find<CourseRepository>(),
    //   ),
    //   fenix: true,
    // );

    // Get.lazyPut<AddCourseController>(
    //   () => AddCourseController(),
    //   fenix: true,
    // );

    Get.lazyPut<AssignmentController>(
      () => AssignmentController(),
      fenix: true,
    );

    // Get.lazyPut(
    //   () => StudentAssignmentController(
    //     courseOfferingId: Get.arguments['courseOfferingId'],
    //   ),
    // );
    Get.lazyPut<AllAssignmentsController>(
      () => AllAssignmentsController(),
      fenix: true,
    );

    Get.lazyPut<SubmissionController>(
      () => SubmissionController(
        repository: Get.find<SubmissionRepository>(),
        service: Get.find<SubmissionService>(),
        userRepo: Get.find<UserRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ChatController>(
      () => ChatController(),
      fenix: true,
    );

    Get.lazyPut<PeopleController>(
      () => PeopleController(),
      fenix: true,
    );

    Get.lazyPut<AttendanceController>(
      () => AttendanceController(),
      fenix: true,
    );

    Get.lazyPut<LecturesController>(() => LecturesController());
  }
}
