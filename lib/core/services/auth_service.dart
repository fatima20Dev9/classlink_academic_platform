import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_service.dart';

// Low level wrapper around FirebaseAuth + the 'users' collection
class AuthService {
  final FirebaseService _fb = FirebaseService.instance;

  Stream<User?> authChanges() => _fb.auth.authStateChanges();

  User? get currentUser => _fb.auth.currentUser;

  Future<User?> signUp({
    required String email,
    required String password,
    // required String name,
    required String role, // 'student' | 'instructor'
    String majorId = '',
    String specialization = '',
    int level = 0,
  }) async {
    final cred = await _fb.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      await _fb.users.doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        // 'name': name,
        'role': role,
        'level': level,
        'majorId': majorId,
        'specialization': specialization,
        'colorIndex': 0,
        'createdAt': Timestamp.now(),
      });
    }
    return user;
  }

  Future<User?> login(String email, String password) async {
    final cred = await _fb.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      final ref = _fb.users.doc(user.uid);
      final doc = await ref.get();
      if (!doc.exists) {
        await ref.set({
          'uid': user.uid,
          'email': email,
          'name': email.split('@').first,
          'role': 'student',
          'colorIndex': 0,
          'createdAt': Timestamp.now(),
        });
      } else if (!(doc.data()!).containsKey('colorIndex')) {
        await ref.update({'colorIndex': 0});
      }
    }
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    await _fb.auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() => _fb.auth.signOut();

  Future<String> getUserRole(String uid) async {
    final doc = await _fb.users.doc(uid).get();
    if (!doc.exists) return 'student';
    final data = doc.data();
    return (data?['role'] as String?) ?? 'student';
  }

  Future<Map<String, dynamic>?> getUserDoc(String uid) async {
    final doc = await _fb.users.doc(uid).get();
    return doc.data();
  }
}
