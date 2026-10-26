import 'package:get/get.dart';

/// Centralized translations for the app.
/// Add new keys here. Use them in UI via: 'key'.tr
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'ar': _ar,
      };

  static const Map<String, String> _en = {
    // App
    'app_title': 'ClassLink',

    // Common
    'common.ok': 'OK',
    'common.cancel': 'Cancel',
    'common.confirm': 'Confirm',
    'common.save': 'Save',
    'common.delete': 'Delete',
    'common.edit': 'Edit',
    'common.add': 'Add',
    'common.search': 'Search',
    'common.loading': 'Loading...',
    'common.error': 'Something went wrong',
    'common.retry': 'Retry',
    'common.empty': 'Nothing here yet',
    'common.yes': 'Yes',
    'common.no': 'No',
    'common.back': 'Back',
    'common.next': 'Next',
    'common.submit': 'Submit',

    // Settings
    'settings.title': 'Settings',
    'settings.general': 'General',
    'settings.about': 'About',
    'settings.darkMode': 'Dark Mode',
    'settings.darkMode.subtitle': 'Change application theme',
    'settings.language': 'Language',
    'settings.language.subtitle': 'Application language',
    'settings.language.en': 'English',
    'settings.language.ar': 'العربية',
    'settings.notifications': 'Notifications',
    'settings.notifications.subtitle': 'Manage notifications',
    'settings.version': 'Version',
    'settings.aboutApp': 'About App',
    'settings.aboutApp.subtitle': 'Learn more about the application',
    'settings.support': 'Contact Support',
    'settings.support.subtitle': 'Need help?',
    'settings.logout': 'Logout',
    'settings.logout.confirm': 'Are you sure you want to logout?',

    // Auth
    'auth.login': 'Login',
    'auth.signup': 'Sign Up',
    'auth.email': 'Email',
    'auth.password': 'Password',
    'auth.forgotPassword': 'Forgot Password?',
    'auth.welcome': 'Welcome back',

    // Roles
    'role.student': 'Student',
    'role.instructor': 'Instructor',

    // Home / Nav
    'nav.home': 'Home',
    'nav.courses': 'Courses',
    'nav.chat': 'Chat',
    'nav.profile': 'Profile',
    'nav.settings': 'Settings',

    // Courses
    'courses.title': 'Courses',
    'courses.enrolled': 'Enrolled Courses',
    'courses.add': 'Add Course',
    'courses.join': 'Join Course',
    'courses.empty': 'No courses yet',
    'courses.instructor': 'Instructor',
    'courses.semester': 'Semester',

    // Assignments
    'assignments.title': 'Assignments',
    'assignments.create': 'Create Assignment',
    'assignments.dueDate': 'Due Date',
    'assignments.empty': 'No assignments',

    // People
    'people.title': 'People',
    'people.students': 'Students',
    'people.instructors': 'Instructors',

    // Chat
    'chat.title': 'Chat',
    'chat.message': 'Message',
    'chat.send': 'Send',

    // Profile
    'profile.title': 'Profile',
    'profile.edit': 'Edit Profile',
  };

  static const Map<String, String> _ar = {
    // App
    'app_title': 'كلاس لينك',

    // Common
    'common.ok': 'موافق',
    'common.cancel': 'إلغاء',
    'common.confirm': 'تأكيد',
    'common.save': 'حفظ',
    'common.delete': 'حذف',
    'common.edit': 'تعديل',
    'common.add': 'إضافة',
    'common.search': 'بحث',
    'common.loading': 'جارٍ التحميل...',
    'common.error': 'حدث خطأ ما',
    'common.retry': 'إعادة المحاولة',
    'common.empty': 'لا يوجد شيء هنا بعد',
    'common.yes': 'نعم',
    'common.no': 'لا',
    'common.back': 'رجوع',
    'common.next': 'التالي',
    'common.submit': 'إرسال',

    // Settings
    'settings.title': 'الإعدادات',
    'settings.general': 'عام',
    'settings.about': 'حول',
    'settings.darkMode': 'الوضع الداكن',
    'settings.darkMode.subtitle': 'تغيير مظهر التطبيق',
    'settings.language': 'اللغة',
    'settings.language.subtitle': 'لغة التطبيق',
    'settings.language.en': 'English',
    'settings.language.ar': 'العربية',
    'settings.notifications': 'الإشعارات',
    'settings.notifications.subtitle': 'إدارة الإشعارات',
    'settings.version': 'الإصدار',
    'settings.aboutApp': 'حول التطبيق',
    'settings.aboutApp.subtitle': 'تعرّف على المزيد حول التطبيق',
    'settings.support': 'تواصل مع الدعم',
    'settings.support.subtitle': 'تحتاج مساعدة؟',
    'settings.logout': 'تسجيل الخروج',
    'settings.logout.confirm': 'هل أنت متأكد من تسجيل الخروج؟',

    // Auth
    'auth.login': 'تسجيل الدخول',
    'auth.signup': 'إنشاء حساب',
    'auth.email': 'البريد الإلكتروني',
    'auth.password': 'كلمة المرور',
    'auth.forgotPassword': 'نسيت كلمة المرور؟',
    'auth.welcome': 'مرحبًا بعودتك',

    // Roles
    'role.student': 'طالب',
    'role.instructor': 'مدرّس',

    // Home / Nav
    'nav.home': 'الرئيسية',
    'nav.courses': 'المقررات',
    'nav.chat': 'المحادثات',
    'nav.profile': 'الملف الشخصي',
    'nav.settings': 'الإعدادات',

    // Courses
    'courses.title': 'المقررات',
    'courses.enrolled': 'المقررات المسجَّلة',
    'courses.add': 'إضافة مقرر',
    'courses.join': 'الانضمام إلى مقرر',
    'courses.empty': 'لا توجد مقررات بعد',
    'courses.instructor': 'المدرّس',
    'courses.semester': 'الفصل الدراسي',

    // Assignments
    'assignments.title': 'الواجبات',
    'assignments.create': 'إنشاء واجب',
    'assignments.dueDate': 'تاريخ التسليم',
    'assignments.empty': 'لا توجد واجبات',

    // People
    'people.title': 'الأشخاص',
    'people.students': 'الطلاب',
    'people.instructors': 'المدرّسون',

    // Chat
    'chat.title': 'المحادثات',
    'chat.message': 'رسالة',
    'chat.send': 'إرسال',

    // Profile
    'profile.title': 'الملف الشخصي',
    'profile.edit': 'تعديل الملف الشخصي',
  };
}
