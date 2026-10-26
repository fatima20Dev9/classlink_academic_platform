import 'package:get/get.dart';

import '../../../models/wrappers/assignment_with_submission.dart';
import '../../../models/enums/assignment_filter.dart';
import '../../../repositories/assignment_repository.dart';
import '/features/auth/controllers/session_controller.dart';

class StudentAssignmentController extends GetxController {
  final AssignmentRepository _repo;

  StudentAssignmentController({
    AssignmentRepository? repo,
    required this.courseOfferingId,
  }) : _repo = repo ?? AssignmentRepository();

  final String courseOfferingId;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<AssignmentWithSubmission> assignments =
      <AssignmentWithSubmission>[].obs;

  final SessionController _session = Get.find<SessionController>();

  final Rx<AssignmentFilter> filter = AssignmentFilter.all.obs;

  bool get hasError => error.value.isNotEmpty;
  String get errorMessage => error.value;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _session.uid;

      if (userId.isEmpty) {
        assignments.clear();
        return;
      }

      final result = await _repo.getStudentAssignments(
        courseOfferingId: courseOfferingId,
        studentId: userId,
      );

      assignments.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      assignments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<AssignmentWithSubmission> get filteredAssignments {
    switch (filter.value) {
      case AssignmentFilter.pending:
        return assignments.where((a) => a.isPending).toList();

      case AssignmentFilter.submitted:
        return assignments.where((a) => a.isSubmitted).toList();

      case AssignmentFilter.all:
      default:
        return assignments;
    }
  }

  void changeFilter(AssignmentFilter newFilter) {
    filter.value = newFilter;
  }

  Future<void> refresh() async {
    await loadAssignments();
  }
}