import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/file_model.dart';
import '/models/lecture_model.dart';
import '../../controllers/lectures_controller.dart';

class AddLectureWidget extends StatefulWidget {
  final String courseOfferingId;

  const AddLectureWidget({
    super.key,
    required this.courseOfferingId,
  });

  @override
  State<AddLectureWidget> createState() => _AddLectureWidgetState();
}

class _AddLectureWidgetState extends State<AddLectureWidget> {
  final LecturesController controller = Get.find();

  File? selectedFile;
  String fileName = "";
  double fileSize = 0;
  String fileType = "";

  bool isUploading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      setState(() {
        selectedFile = File(file.path!);
        fileName = file.name;
        fileSize = file.size / (1024 * 1024); // MB
        fileType = file.extension ?? "file";
      });
    }
  }

  Future<void> uploadLecture() async {
    if (selectedFile == null) return;

    try {
      setState(() => isUploading = true);

      // 1️⃣ رفع الملف إلى Firebase Storage
      final downloadUrl = await controller.uploadFile(
        selectedFile!.path,
      );

      // 2️⃣ تجهيز البيانات
      final lecture = {
        "courseOfferingId": widget.courseOfferingId,
        "file": {
          "url": downloadUrl,
          "name": fileName,
          "size": fileSize,
          "type": fileType,
        },
        "createdAt": Timestamp.now(),      
      };

      // 3️⃣ حفظ في Firestore
      await controller.addLecture(lecture);

      // 4️⃣ إعادة تحميل البيانات
      await controller.loadLectures(widget.courseOfferingId);

      Get.back();
      Get.snackbar("Success", "Lecture added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Lecture",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: pickFile,
            icon: const Icon(Icons.attach_file),
            label: const Text("Pick File"),
          ),

          const SizedBox(height: 12),

          if (selectedFile != null)
            Text(
              "Selected: $fileName",
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 20),

          isUploading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: uploadLecture,
                  child: const Text("Upload"),
                ),
        ],
      ),
    );
  }
}