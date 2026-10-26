import 'package:get/get.dart';

import '../../../core/services/people_service.dart';
import '../../auth/controllers/session_controller.dart';

class PeopleController extends GetxController {
  final PeopleService _service = Get.find<PeopleService>();
  final SessionController _session = Get.find<SessionController>();

  // =====================
  // STATE
  // =====================
  final RxBool isLoading = false.obs;

  /// جميع الأشخاص داخل نفس الكورس
  final RxList<Map<String, dynamic>> people =
      <Map<String, dynamic>>[].obs;

  /// فلترة البحث
  final RxList<Map<String, dynamic>> filteredPeople =
      <Map<String, dynamic>>[].obs;

  // =====================
  // LOAD PEOPLE (BY COURSE)
  // =====================
  Future<void> loadPeople(String courseOfferingId) async {
    try {
      isLoading.value = true;

      final data = await _service.getCoursePeople(courseOfferingId);

      people.assignAll(data);
      filteredPeople.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  // =====================
  // SEARCH PEOPLE
  // =====================
  void search(String keyword) {
    if (keyword.isEmpty) {
      filteredPeople.assignAll(people);
      return;
    }

    final result = people.where((user) {
      final name = (user['name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();

      return name.contains(keyword.toLowerCase()) ||
          email.contains(keyword.toLowerCase());
    }).toList();

    filteredPeople.assignAll(result);
  }

  // =====================
  // CLEAR STATE
  // =====================
  void clear() {
    people.clear();
    filteredPeople.clear();
  }
}