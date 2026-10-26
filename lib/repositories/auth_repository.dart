import '../core/services/auth_service.dart';
import '../core/services/user_service.dart';
import '../models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _auth = AuthService();
  final UserService _users = UserService();

  Stream get authChanges => _auth.authChanges();
  String? get currentUid => _auth.currentUser?.uid;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    // required String name,
    required String role,
    String majorId = '',
    String specialization = '',
    int level = 0,
  }) async {
    final user = await _auth.signUp(
      email: email,
      password: password,
      // name: name,
      role: role,
      majorId: majorId,
      specialization: specialization,
      level: level,
    );
    if (user == null) return null;
    return _users.fetchUser(user.uid);
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _auth.login(email, password);
    if (user == null) return null;
    return _users.fetchUser(user.uid);
  }

  Future<void> logout() => _auth.logout();

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordReset(email);

  Future<UserModel?> currentUserModel() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _users.fetchUser(uid);
  }

  Future<String> fetchRole(String uid) => _auth.getUserRole(uid);

  Future<void> completeProfile({
    required String name,
    required String phone,
    required String? specialization,
    String? level,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
      'specialization': specialization,
      'level': int.tryParse(level ?? '0') ?? 0,
      'profileCompleted': true,
    });
  }
}
