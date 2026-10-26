import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Centralised Firebase access
// (all collection references live here so that renaming a collection is a single-point change)

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  String? get currentUid => auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get colleges =>
      firestore.collection('colleges');
  CollectionReference<Map<String, dynamic>> get majors =>
      firestore.collection('majors');
  CollectionReference<Map<String, dynamic>> get courses =>
      firestore.collection('courses');
  CollectionReference<Map<String, dynamic>> get courseOfferings =>
      firestore.collection('courseOfferings');
  CollectionReference<Map<String, dynamic>> get enrollments =>
      firestore.collection('enrollments');
  CollectionReference<Map<String, dynamic>> get assignments =>
      firestore.collection('assignments');
  CollectionReference<Map<String, dynamic>> get submissions =>
      firestore.collection('submissions');
  CollectionReference<Map<String, dynamic>> get lectures =>
      firestore.collection('lectures');
  CollectionReference<Map<String, dynamic>> get attendance =>
      firestore.collection('attendance');
  CollectionReference<Map<String, dynamic>> get chats =>
      firestore.collection('chats');

  CollectionReference<Map<String, dynamic>> messagesOf(String chatId) =>
      chats.doc(chatId).collection('messages');
}
