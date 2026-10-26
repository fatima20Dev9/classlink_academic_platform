import 'package:get/get.dart';
import '/models/submission_model.dart';
import '/repositories/submission_repository.dart';
import '../../../core/services/submission_service.dart';
import '../../../repositories/user_repository.dart';

class SubmissionController extends GetxController {
  final SubmissionRepository repository;
  final SubmissionService service;
  final UserRepository userRepo;

  SubmissionController({
    required this.repository,
    required this.service,
    required this.userRepo,
  });

Future<List<SubmissionModel>> enrichSubmissions(
  List<SubmissionModel> submissions,
) async {
  final enriched = <SubmissionModel>[];

  for (final sub in submissions) {
    final user = await userRepo.byId(sub.studentId);

    if (user != null) {
      enriched.add(
        sub.copyWithUser(user),
      );
    } else {
      enriched.add(sub);
    }
  }

  return enriched;
}
  /// ================= STATE =================
  var submissions = <SubmissionModel>[].obs;

  var isLoading = true.obs;

  /// ================= STATS =================
  var total = 0.obs;
  var handedIn = 0.obs;
  var marked = 0.obs;
  var pending = 0.obs;

  /// ================= INIT LISTENER =================
  void listenToAssignment(String assignmentId) {
    isLoading.value = true;

    repository.getSubmissionsByAssignment(assignmentId).listen((data) {
      submissions.value = data;

      _calculateStats();

      isLoading.value = false;
    });
  }

  /// ================= CALCULATE STATS =================
  void _calculateStats() {
    total.value = service.countTotal(submissions);
    handedIn.value = service.countHandedIn(submissions);
    marked.value = service.countMarked(submissions);
    pending.value = service.countPending(submissions);
  }

  /// ================= FILTERS =================
  List<SubmissionModel> get handedInList =>
      service.filterByStatus(submissions, SubmissionStatus.handedIn);

  List<SubmissionModel> get markedList =>
      service.filterByStatus(submissions, SubmissionStatus.marked);

  List<SubmissionModel> get pendingList =>
      service.filterByStatus(submissions, SubmissionStatus.pending);

  /// ================= STUDENT ACTIONS =================
  Future<void> submit({
    required String assignmentId,
    required String studentId,
    Map<String, dynamic>? file,
  }) async {
    await repository.submitAssignment(
      assignmentId: assignmentId,
      studentId: studentId,
      file: file,
    );
  }

  Future<void> updateSubmission({
    required String submissionId,
    Map<String, dynamic>? file,
  }) async {
    await repository.updateSubmission(
      submissionId: submissionId,
      file: file,
    );
  }

  Future<void> deleteSubmission(String id) async {
    await repository.deleteSubmission(id);
  }

  /// ================= INSTRUCTOR ACTIONS =================
  Future<void> markSubmission({
    required String id,
    required double grade,
  }) async {
    await repository.gradeSubmission(
      submissionId: id,
      grade: grade,
    );
  }

  Future<void> changeStatus({
    required String id,
    required SubmissionStatus status,
  }) async {
    await repository.updateStatus(
      submissionId: id,
      status: status.name,
    );
  }

  /// ================= HELPERS =================
  bool canSubmit(DateTime dueDate) {
    return service.canSubmit(dueDate);
  }

  bool canEdit(SubmissionModel submission) {
    return service.canEditSubmission(submission);
  }

  bool canDelete(SubmissionModel submission) {
    return service.canDeleteSubmission(submission);
  }
}