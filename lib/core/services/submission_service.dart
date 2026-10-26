import '/models/submission_model.dart';

class SubmissionService {
  /// ================= STATUS CHECK =================
  bool isClosed(DateTime dueDate) {
    return DateTime.now().isAfter(dueDate);
  }

  bool isActive(DateTime dueDate) {
    return DateTime.now().isBefore(dueDate) ||
        DateTime.now().isAtSameMomentAs(dueDate);
  }

  /// ================= SUBMISSION STATUS LOGIC =================
  SubmissionStatus getStatus(SubmissionModel submission) {
    if (submission.grade != null) {
      return SubmissionStatus.marked;
    }

    if (submission.file != null) {
      return SubmissionStatus.handedIn;
    }

    return SubmissionStatus.pending;
  }

  /// ================= COUNTERS (FOR UI DASHBOARD) =================
  int countHandedIn(List<SubmissionModel> list) {
    return list.where((e) => e.submissionStatus == SubmissionStatus.handedIn).length;
  }

  int countMarked(List<SubmissionModel> list) {
    return list.where((e) => e.submissionStatus == SubmissionStatus.marked).length;
  }

  int countPending(List<SubmissionModel> list) {
    return list.where((e) => e.submissionStatus == SubmissionStatus.pending).length;
  }

  int countTotal(List<SubmissionModel> list) {
    return list.length;
  }

  /// ================= FILTERING =================
  List<SubmissionModel> filterByStatus(
    List<SubmissionModel> list,
    SubmissionStatus status,
  ) {
    return list.where((e) => e.submissionStatus == status).toList();
  }

  /// ================= VALIDATION =================
  bool canSubmit(DateTime dueDate) {
    return isActive(dueDate);
  }

  bool canEditSubmission(SubmissionModel submission) {
    return submission.submissionStatus != SubmissionStatus.marked;
  }

  bool canDeleteSubmission(SubmissionModel submission) {
    return submission.submissionStatus == SubmissionStatus.pending ||
        submission.submissionStatus == SubmissionStatus.handedIn;
  }
}