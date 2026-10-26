import 'package:get/get.dart';

import '../../../core/utils/base_controller.dart';
import '../../../core/utils/load_status.dart';
import '../../../repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';
import 'session_controller.dart';
import '../screens/role_redirect_screen.dart';
// import '../../../features/auth/screens/role_redirect_screen.dart';

class AuthController extends BaseController {
  final AuthRepository _repo = AuthRepository();
  late final SessionController _session = Get.find<SessionController>();

  final RxBool obscurePassword = true.obs;

  Future<void> login(String email, String password) async {
    final user = await runGuarded(() => _repo.login(email, password));
    if (user != null) {
      _session.setUser(user);
      Get.offAllNamed(AppRoutes.roleRedirect);
    } else if (status.value.isError) {
      Get.snackbar('Login failed', errorMessage.value);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    // required String name,
    required String role,
  }) async {
    final user = await runGuarded(() => _repo.signUp(
          email: email,
          password: password,
          // name: name,
          role: role,
        ));
    if (user != null) {
      _session.setUser(user);
      Get.offAllNamed(AppRoutes.roleRedirect);
    } else if (status.value.isError) {
      Get.snackbar('Sign up failed', errorMessage.value);
    }
  }

  Future<void> sendReset(String email) async {
    await runGuarded(() => _repo.sendPasswordReset(email));
    if (status.value.isSuccess) {
      Get.snackbar('Email sent', 'Check your inbox for the reset link');
    } else if (status.value.isError) {
      Get.snackbar('Failed', errorMessage.value);
    }
  }

  Future<void> logout() async {
    await _session.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> completeProfile({
    required String name,
    required String phone,
    required String? specialization,
    String? level,
  }) async {
    await runGuarded(() async {
      await _repo.completeProfile(
        name: name,
        phone: phone,
        specialization: specialization,
        level: level,
      );

      await _session.loadCurrentUser();
    });

    if (status.value.isSuccess) {
      Get.offAll(() => RoleRedirectScreen());
    } else if (status.value.isError) {
      Get.snackbar(
        'Error',
        errorMessage.value,
      );
    }
  }
}
