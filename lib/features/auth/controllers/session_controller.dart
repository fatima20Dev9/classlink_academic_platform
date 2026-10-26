import 'package:get/get.dart';

import '../../../core/utils/base_controller.dart';
import '../../../models/users_model.dart';
import '../../../repositories/auth_repository.dart';

// Holds the currently logged-in user (with role)
//and reviewed by every screen that needs role-based behaviour

class SessionController extends BaseController {
  final AuthRepository _repo = AuthRepository();

  // Current logged-in user
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // =========================
  // Getters
  // =========================

  UserModel? get user => currentUser.value;

  String get uid => user?.uid ?? '';

  String get role => user?.role.name ?? 'student';

  String get name => user?.name ?? '';

  String get email => user?.email ?? '';

  String get phone => user?.phone ?? '';

  String get specialization => user?.specialization ?? '';

  int get level => user?.level ?? 0;

  String get majorId => user?.majorId ?? '';

  bool get isStudent => user?.isStudent ?? true;

  bool get isInstructor => user?.isInstructor ?? false;

  bool get profileCompleted => user?.profileCompleted ?? false;

  bool get isLoggedIn => user != null;

  // =========================
  // Load current user
  // =========================

  Future<void> loadCurrentUser() async {
    await runGuarded(() async {
      final u = await _repo.currentUserModel();

      currentUser.value = u;

      return u;
    });
  }

  // =========================
  // Set user manually
  // =========================

  void setUser(UserModel? u) {
    currentUser.value = u;
  }

  // =========================
  // Refresh session data
  // =========================

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  // =========================
  // Logout
  // =========================

  Future<void> logout() async {
    await _repo.logout();

    currentUser.value = null;
  }
}
