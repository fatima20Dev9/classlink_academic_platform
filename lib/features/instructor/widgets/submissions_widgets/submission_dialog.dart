import 'package:flutter/material.dart';
import '/models/submission_model.dart';

class SubmissionDialog extends StatefulWidget {
  final SubmissionModel submission;
  final String studentName;
  final String? fileName;
  final double maxGrade;
  final Future<void> Function(double grade) onSubmit;

  const SubmissionDialog({
    super.key,
    required this.submission,
    required this.studentName,
    required this.maxGrade,
    required this.onSubmit,
    this.fileName,
  });

  @override
  State<SubmissionDialog> createState() => _SubmissionDialogState();
}

class _SubmissionDialogState extends State<SubmissionDialog> {
  final TextEditingController gradeController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // إذا كان هناك درجة مسبقة
    if (widget.submission.grade != null) {
      gradeController.text = widget.submission.grade.toString();
    }
  }

  Future<void> submitGrade() async {
    final grade = double.tryParse(gradeController.text);

    if (grade == null) return;

    setState(() => isLoading = true);

    await widget.onSubmit(grade);

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STUDENT INFO
            Text(
              widget.studentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.fileName ?? "No file submitted",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            /// GRADE INPUT
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Grade",
                hintText: "Max ${widget.maxGrade}",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: isLoading ? null : submitGrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1B4B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}