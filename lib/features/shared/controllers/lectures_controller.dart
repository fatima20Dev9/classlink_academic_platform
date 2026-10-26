import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/services/notification_dispatcher.dart';
import '../../../models/lecture_model.dart';
import '../../../repositories/lecture_repository.dart';

class LecturesController extends GetxController {
  final LectureRepository _repo;
  final NotificationDispatcher _dispatcher;

  LecturesController({
    LectureRepository? repo,
    NotificationDispatcher? dispatcher,
  })  : _repo = repo ?? LectureRepository(),
        _dispatcher = dispatcher ??
            (Get.isRegistered<NotificationDispatcher>()
                ? Get.find<NotificationDispatcher>()
                : NotificationDispatcher());

  final RxBool isLoading = false.obs;
  final RxList<LectureModel> lectures = <LectureModel>[].obs;
  final RxString error = ''.obs;

  final RxString selectedFilePath = ''.obs;
  final RxString selectedFileName = ''.obs;

  Future<void> loadLectures(String courseOfferingId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _repo.getByCourseOffering(courseOfferingId);
      lectures.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      selectedFilePath.value = result.files.single.path!;
      selectedFileName.value = result.files.single.name;
    }
  }

  Future<String> uploadFile(String filePath) async {
    return await _repo.uploadFile(filePath);
  }

  Future<String> addLecture(Map<String, dynamic> data) async {
    return await _repo.addLecture(data);
  }

  /// FULL FLOW: upload + save + notify enrolled students.
  Future<void> createLecture(String courseOfferingId) async {
    if (selectedFilePath.value.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = '';

      final url = await _repo.uploadFile(selectedFilePath.value);
      final fileName = selectedFileName.value;

      final lectureId = await _repo.addLecture({
        "courseOfferingId": courseOfferingId,
        "file": {
          "name": fileName,
          "url": url,
          "size": 0,
          "type": _getFileType(fileName),
        },
        "createdAt": DateTime.now(),
      });

      // ignore: unawaited_futures
      _dispatcher.lectureUploaded(
        courseOfferingId: courseOfferingId,
        lectureId: lectureId,
        fileName: fileName,
      );

      await loadLectures(courseOfferingId);

      selectedFilePath.value = '';
      selectedFileName.value = '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String _getFileType(String name) {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'word';
      case 'ppt':
      case 'pptx':
        return 'ppt';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'file';
    }
  }
}
