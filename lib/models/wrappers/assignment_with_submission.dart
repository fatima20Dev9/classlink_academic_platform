import '../assignment_model.dart';
import '../submission_model.dart';

class AssignmentWithSubmission {
  final AssignmentModel assignment;
  final SubmissionModel? submission;

  const AssignmentWithSubmission({
    required this.assignment,
    this.submission,
  });

  bool get isSubmitted {
    return submission != null;
  }

  bool get isPending {
    return submission == null;
  }

  String get submissionFileName {
    return submission?.file?.name ?? '';
  }

  String get submissionFileSize {
    return submission?.file?.formattedSize ?? '';
  }

  DateTime? get submittedAt {
    return submission?.submittedAt.toDate();
  }

  String get studentStatus {
    return isSubmitted ? 'Submitted' : 'Pending';
  }

  bool get canSubmit {
    return assignment.isActive && !isSubmitted;
  }

  bool get isClosedWithoutSubmission {
    return assignment.isClosed && !isSubmitted;
  }
}
