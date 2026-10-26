import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/features/auth/controllers/session_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Color primaryColor = const Color(0xFF1E1B4B);
  final Color backgroundColor = const Color(0xFFF3F4F6);
  final Color whiteColor = const Color(0xFFFFFFFF);

  /// Session Controller
  final SessionController session = Get.find<SessionController>();

  @override
  Widget build(BuildContext context) {
    /// بيانات المستخدم
    final user = session.user;

    final String name =
        user?.name.trim().isNotEmpty == true ? user!.name : 'Student';

    final String email = user?.email ?? 'No Email';

    /// يمكنك لاحقاً جلب هذه القيم من firestore
    final String studentId = user?.uid.substring(0, 8) ?? 'N/A';

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),

      body: 
      SingleChildScrollView(
        child: Column(
          children: [
            /// =========================
            /// HEADER
            /// =========================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(
                bottom: 30,
                top: 0,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: whiteColor,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ID: $studentId",
                    style: TextStyle(
                      color: whiteColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            /// =========================
            /// PROFILE DETAILS
            /// =========================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileItem(
                    Icons.email,
                    "Email",
                    email,
                  ),

                  _buildProfileItem(
                    Icons.phone,
                    "Phone",
                    user?.phone.isNotEmpty == true ? user!.phone : 'No Phone',
                  ),

                  _buildProfileItem(
                    Icons.school,
                    "Role",
                    user?.isInstructor == true ? 'Instructor' : 'Student',
                  ),

                  _buildProfileItem(
                    Icons.menu_book,
                    "Specialization",
                    user?.specialization.isNotEmpty == true
                        ? user!.specialization
                        : 'Not Specified',
                  ),

                  /// يظهر فقط للطالب
                  if (user?.isStudent == true)
                    _buildProfileItem(
                      Icons.calendar_today,
                      "Academic Level",
                      user!.level > 0 ? 'Level ${user.level}' : 'Not Specified',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// =========================
      /// LOGOUT BUTTON
      /// =========================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout?'),
                  content: const Text(
                    'Are you sure you want to logout from your account?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);

                        /// تسجيل الخروج
                        await session.logout();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// PROFILE ITEM
  /// =========================
  Widget _buildProfileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
