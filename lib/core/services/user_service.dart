import '../../models/users_model.dart';
import 'firebase_service.dart';

// to deal with the firebase operations related to the user
class UserService {
  final FirebaseService _fb = FirebaseService.instance;

  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _fb.users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'uid': uid});
  }

  Future<List<UserModel>> fetchAll() async {
    final snap = await _fb.users.get();
    return snap.docs
        .map((d) => UserModel.fromJson({...d.data(), 'uid': d.id}))
        .toList();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _fb.users.doc(uid).update(data);
  }
}
