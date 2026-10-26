import 'package:get/get.dart';

import '../features/shared/screens/splash_screen.dart';
import '../features/auth/auth_gate.dart';
import '../features/auth/screens/forgetpassword.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/shared/screens/all_enrolled_courses.dart';
import '../features/shared/screens/chat_conversation.dart';
import '../features/shared/screens/profile.dart';
import '../features/shared/screens/schedule_exam.dart';
import '../features/shared/screens/tab_chat.dart';
import '../features/student/screens/barcode_scanner.dart';
import '../features/student/screens/schedule_lectures.dart';
import '../features/shared/screens/add_course.dart';
import '../features/shared/bindings/add_course_binding.dart';
import '../features/shared/screens/notifications_screen.dart';
import 'app_routes.dart';

// page registry consumed by GetMaterialApp
class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgetPasswordPage(),
    ),
    GetPage(name: AppRoutes.home, page: () => const AuthGate()),
    GetPage(
      name: AppRoutes.allCourses,
      page: () => const AllEnrolledCoursesPage(),
    ),
    GetPage(name: AppRoutes.profile, page: () => ProfilePage()),
    GetPage(name: AppRoutes.chat, page: () => const ChatPage()),
    
    GetPage(
      name: AppRoutes.scheduleExam,
      page: () => const ScheduleExamScreen(),
    ),
    GetPage(
      name: AppRoutes.scheduleLectures,
      page: () => const LectureSchedulePage(),
    ),
    GetPage(
      name: AppRoutes.barcodeScanner,
      page: () => const BarcodeScannerPage(),
    ),
    GetPage(
      name: AppRoutes.chatConversation,
      page: () => const ChatConversationScreen(),
    ),
    GetPage(
      name: '/add-course',
      page: () => const AddCoursePage(),
      binding: AddCourseBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    
    
  ];
}
