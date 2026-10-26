import '../core/services/user_service.dart';
import '../models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<UserModel?> byId(String uid) => _service.fetchUser(uid);
  Future<List<UserModel>> all() => _service.fetchAll();
  Future<void> update(String uid, Map<String, dynamic> data) =>
      _service.updateUser(uid, data);
  Future<String> getUserName(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) return 'Unknown Instructor';

    return doc.data()?['name'] ?? 'Unknown Instructor';
  }
}
