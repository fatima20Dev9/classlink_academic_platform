import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/screens/bottom_navigation.dart';
import '../controllers/session_controller.dart';

// After login, this screen ensures the SessionController has loaded the
// user model and then redirects to the main app shell with role-based navigation

class RoleRedirectScreen extends StatefulWidget {
  const RoleRedirectScreen({super.key});

  @override
  State<RoleRedirectScreen> createState() => _RoleRedirectScreenState();
}

class _RoleRedirectScreenState extends State<RoleRedirectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = Get.find<SessionController>();
      if (session.currentUser.value == null) {
        await session.loadCurrentUser();
      }
      if (!mounted) return;
      Get.offAll(() => BottomNavigationPage(role: session.role));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
