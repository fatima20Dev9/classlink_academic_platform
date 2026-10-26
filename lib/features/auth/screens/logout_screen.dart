import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/screens/bottom_navigation.dart';
import '../controllers/auth_controller.dart';
import '../controllers/session_controller.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Go back to the main app shell
                      Get.offAll(
                          () => BottomNavigationPage(role: session.role));
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Get.find<AuthController>().logout(),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
