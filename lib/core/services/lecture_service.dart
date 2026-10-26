import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/lecture_model.dart';
import 'firebase_service.dart';

class LectureService {
  final FirebaseService _fb = FirebaseService.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // =========================================
  // GET LECTURES BY COURSE OFFERING
  // =========================================
  Future<List<LectureModel>> getByCourseOffering(
    String courseOfferingId,
  ) async {
    final snapshot = await _fb.lectures
        .where('courseOfferingId', isEqualTo: courseOfferingId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((e) => LectureModel.fromJson(e.data(), e.id))
        .toList();
  }

  // =========================================
  // ADD LECTURE (Firestore)
  // =========================================
  Future<String> addLecture(Map<String, dynamic> data) async {
    final ref = await _fb.lectures.add(data);
    return ref.id;
  }

  // =========================================
  // DELETE LECTURE
  // =========================================
  Future<void> deleteLecture(String id) async {
    await _fb.lectures.doc(id).delete();
  }

  // =========================================
  // UPLOAD FILE TO FIREBASE STORAGE
  // =========================================
  Future<String> uploadFile(String filePath) async {
    final file = File(filePath);

    final fileName = filePath.split('/').last;

    final ref = _storage.ref()
        .child('lectures')
        .child(fileName);

    final uploadTask = await ref.putFile(file);

    final url = await uploadTask.ref.getDownloadURL();

    return url;
  }
}