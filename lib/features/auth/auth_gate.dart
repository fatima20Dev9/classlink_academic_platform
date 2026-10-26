import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../../features/auth/controllers/session_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/shared/screens/bottom_navigation.dart';
import '../../models/users_model.dart';
import '../../repositories/user_repository.dart';
import '../../features/auth/screens/complete_profile.dart';

// decides which screen to show based on Firebase Auth state and user role document in Firestore 
//This is the single entry point used by GetMaterialApp

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _SplashScaffold();
        }
        final user = authSnap.data;
        if (user == null) {
          return const LoginScreen();
        }
        return FutureBuilder<UserModel?>(
          future: UserRepository().byId(user.uid),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const _SplashScaffold();
            }
            final model = snap.data;
            if (model == null) {
              // build a default user doc from the legacy auth flow
              return FutureBuilder(
                future: AuthService().getUserRole(user.uid),
                builder: (context, roleSnap) {
                  if (!roleSnap.hasData) {
                    return const _SplashScaffold();
                  }
                  if (Get.isRegistered<SessionController>()) {
                    Get.find<SessionController>().loadCurrentUser();
                  }
                  return BottomNavigationPage(role: roleSnap.data!);
                },
              );
            }
            // Make session controller aware of the current user 
            if (Get.isRegistered<SessionController>()) {
              Get.find<SessionController>().setUser(model);
            }

            if (!model.profileCompleted) {
              return CompleteProfileScreen(
                role: model.role.name,
              );
            }
            return BottomNavigationPage(
              role: model.role.name,
            );
            // return BottomNavigationPage(role: model.role.name);
          },
        );
      },
    );
  }
}

class _SplashScaffold extends StatelessWidget {
  const _SplashScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
