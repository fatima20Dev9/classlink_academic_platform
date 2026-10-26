import 'package:flutter/material.dart';
import 'student_submission_card.dart';
import '/models/submission_model.dart';

class SubmissionSection extends StatelessWidget {
  final String title;
  final List<SubmissionModel> submissions;
  final bool isExpanded;
  final VoidCallback onToggle;

  /// بيانات الطلاب (لأنها ليست داخل SubmissionModel)
  final Map<String, String> studentNames;
  final Map<String, String?> studentAvatars;

  const SubmissionSection({
    super.key,
    required this.title,
    required this.submissions,
    required this.isExpanded,
    required this.onToggle,
    required this.studentNames,
    required this.studentAvatars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          /// HEADER
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "${submissions.length}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          /// CONTENT
          if (isExpanded)
            Column(
              children: submissions.map((submission) {
                final studentId = submission.studentId;

                return StudentSubmissionCard(
                  submission: submission,
                  // studentName: studentNames[studentId] ?? "Unknown Student",
                  avatarUrl: studentAvatars[studentId],
                  onTap: () {
                    // open detail dialog or page
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}