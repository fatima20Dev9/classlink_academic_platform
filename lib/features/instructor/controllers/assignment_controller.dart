import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/notification_dispatcher.dart';
import '../../../models/assignment_model.dart';
import '../../../repositories/assignment_repository.dart';

class AssignmentController extends GetxController {
  final AssignmentRepository _repo;
  final NotificationDispatcher _dispatcher;

  AssignmentController({
    AssignmentRepository? repo,
    NotificationDispatcher? dispatcher,
  })  : _repo = repo ?? AssignmentRepository(),
        _dispatcher = dispatcher ??
            (Get.isRegistered<NotificationDispatcher>()
                ? Get.find<NotificationDispatcher>()
                : NotificationDispatcher());


  // =========================
  // STATE
  // =========================
  final RxBool isLoading = false.obs;
  final RxList<AssignmentModel> assignments = <AssignmentModel>[].obs;
  final RxString error = ''.obs;

  File? selectedFile;
  String fileName = '';

  // =========================
  // LOAD
  // =========================
  Future<void> load(String courseOfferingId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.getByCourseOffering(courseOfferingId);
      assignments.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // PICK FILE
  // =========================
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      selectedFile = File(result.files.single.path!);
      fileName = result.files.single.name;
    }
  }

  // =========================
  // CREATE ASSIGNMENT
  // =========================
  Future<void> createAssignment({
    required String courseOfferingId,
    required String instructorId,
    required String title,
    required String description,
    required DateTime dueDate,
    required double maxGrade,
  }) async {
    try {
      isLoading.value = true;

      String? fileUrl;

      if (selectedFile != null) {
        fileUrl = await _repo.uploadFile(selectedFile!, fileName);
      }

      final assignmentId = await _repo.add({
        "courseOfferingId": courseOfferingId,
        "instructorId": instructorId,
        "title": title,
        "description": description,
        "dueDate": Timestamp.fromDate(dueDate),
        "maxGrade": maxGrade,
        "status": "active",
        "file": fileUrl == null
            ? null
            : {
                "url": fileUrl,
                "name": fileName,
                "type": fileName.contains('.')
                ? fileName.split('.').last
                : '',
                "size": selectedFile?.lengthSync() ?? 0,
              },
      });

      // Notify enrolled students (fire-and-forget).
      // ignore: unawaited_futures
      _dispatcher.assignmentCreated(
        courseOfferingId: courseOfferingId,
        assignmentId: assignmentId,
        title: title,
        description: description,
        excludeUid: instructorId,
      );

      await load(courseOfferingId);


      selectedFile = null;
      fileName = '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAssignment(
    String assignmentId,
    String courseOfferingId,
  ) async {
    try {
      isLoading.value = true;

      await _repo.delete(assignmentId);

      assignments.removeWhere(
        (e) => e.id == assignmentId,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAssignment({
      required String courseOfferingId,

    required String assignmentId,
    required String title,
    required String description,
    required DateTime dueDate,
    required double maxGrade,
  }) 
  async {
    try {
      isLoading.value = true;

      await _repo.update(
        assignmentId,
        {
          "title": title,
          "description": description,
          "dueDate": Timestamp.fromDate(dueDate),
          "maxGrade": maxGrade,
        },
      );
      await load(courseOfferingId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
}
