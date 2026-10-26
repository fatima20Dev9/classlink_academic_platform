import 'package:flutter/material.dart';
import '/models/submission_model.dart';
import 'student_submission_card.dart';
import 'submission_dialog.dart';

class StudentWorkView extends StatelessWidget {
  final List<SubmissionModel> submissions;
  final int maxGrade;

  final Future<void> Function(String id, double grade) onMark;

  const StudentWorkView({
    super.key,
    required this.submissions,
    required this.maxGrade,
    required this.onMark,
  });

  @override
  Widget build(BuildContext context) {
    final submittedStudents = submissions
        .where((s) =>
            s.submissionStatus == SubmissionStatus.handedIn ||
            s.submissionStatus == SubmissionStatus.marked
            )
        .toList();

    if (submittedStudents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 60,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                "No submissions yet",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: submittedStudents.length,
      itemBuilder: (context, index) {
        final student = submittedStudents[index];

        return StudentSubmissionCard(
          submission: student,
          // studentName: student.student?.name ?? "Unknown Student",
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => SubmissionDialog(
                submission: student,
                studentName: student.student?.name ?? "Unknown Student",
                fileName: student.file?.name,
                maxGrade: maxGrade.toDouble(),
                onSubmit: (grade) async {
                  await onMark(student.id, grade);
                },
              ),
            );
          },
        );
      },
    );
  }
}