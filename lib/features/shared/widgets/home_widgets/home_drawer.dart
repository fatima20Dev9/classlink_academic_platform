import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../auth/controllers/session_controller.dart';
import '../../../shared/screens/all_enrolled_courses.dart';
import '../../../shared/screens/profile.dart';
import '../../../shared/screens/settings_page.dart';

class HomeDrawer extends StatelessWidget {
  final String role;

  const HomeDrawer({
    super.key,
    required this.role,
  });

  bool get isStudent => role.toLowerCase() == 'student';
  bool get isInstructor => role.toLowerCase() == 'instructor';
  bool get isAdmin => role.toLowerCase() == 'admin';
/// =========================
/// Role label
/// =========================
String get roleLabel {
  if (isStudent) return 'Student Account';
  if (isInstructor) return 'Instructor Account';
  if (isAdmin) return 'Admin Account';
  return 'User Account';
}

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final session = Get.find<SessionController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// HEADER
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: Text(
              session.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              session.email,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Text(
                session.name.isNotEmpty ? session.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          /// COMMON
          _item(
            context,
            icon: Icons.dashboard_outlined,
            text: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),

          _item(
            context,
            icon: Icons.person_outline,
            text: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            },
          ),

          /// COURSES (ROLE BASED)
          if (isStudent)
            _item(
              context,
              icon: Icons.menu_book_outlined,
              text: 'My Enrolled Courses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AllEnrolledCoursesPage(),
                  ),
                );
              },
            ),

          if (isInstructor)
            _item(
              context,
              icon: Icons.menu_book_outlined,
              text: 'My Courses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AllEnrolledCoursesPage(),
                  ),
                );
              },
            ),

          if (isAdmin)
            _item(
              context,
              icon: Icons.admin_panel_settings_outlined,
              text: 'Manage System',
              onTap: () {},
            ),

          /// EXAMS
          // if (!isAdmin)
          //   _item(
          //     context,
          //     icon: Icons.event_note_outlined,
          //     text: 'Exam Schedule',
          //     onTap: () {},
          //   ),

          const Divider(),

          /// SETTINGS
          _item(
            context,
            icon: Icons.settings_outlined,
            text: 'Settings',
            onTap: () {
              Get.to(
                () => const SettingsPage(),
              );
            },
          ),

          /// LOGOUT (with confirmation dialog)
          _item(
            context,
            icon: Icons.logout_rounded,
            text: 'Logout',
            textColor: Theme.of(context).colorScheme.error,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// Logout confirmation dialog
  /// =========================
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final auth = Get.isRegistered<AuthController>()
                  ? Get.find<AuthController>()
                  : Get.put(AuthController(), permanent: true);
              await auth.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}



/// =========================
/// Reusable item
/// =========================
Widget _item(
  BuildContext context, {
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  Color? textColor,
}) {
  return ListTile(
    leading: Icon(icon, color: textColor),
    title: Text(
      text,
      style: TextStyle(color: textColor),
    ),
    onTap: onTap,
  );
}
