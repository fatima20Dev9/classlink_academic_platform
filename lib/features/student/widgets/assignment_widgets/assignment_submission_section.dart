import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../models/wrappers/assignment_with_submission.dart';

import 'assignment_dropzone.dart';
import 'assignment_submission_view.dart';

class AssignmentSubmissionSection extends StatefulWidget {
  final AssignmentWithSubmission item;

  const AssignmentSubmissionSection({
    super.key,
    required this.item,
  });

  @override
  State<AssignmentSubmissionSection> createState() =>
      _AssignmentSubmissionSectionState();
}

class _AssignmentSubmissionSectionState
    extends State<AssignmentSubmissionSection> {
  bool _expanded = false;

  String? _selectedFileName;

  Future<void> _pickFile() async {
    if (widget.item.assignment.isClosed) {
    return;
  }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'zip',
      ],
    );

    if (result == null) return;

    setState(() {
      _selectedFileName = result.files.single.name;
    });

    // TODO:
    // AssignmentController.submitAssignment(...)
  }

  @override
  Widget build(BuildContext context) {
    final submitted = widget.item.isSubmitted;
    final isClosed = widget.item.assignment.isClosed;

    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key: PageStorageKey(
              widget.item.assignment.id,
            ),
            title: Text(
              submitted ? 'View Submission' : 'Submit Assignment',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.blueGrey.shade700,
            ),
            onExpansionChanged: (value) {
              setState(() {
                _expanded = value;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  20,
                ),
                child: submitted
                    ? AssignmentSubmissionView(
                        fileName: widget.item.submissionFileName,
                        fileSize: widget.item.submissionFileSize,
                        submittedAt: widget.item.submittedAt!,
                        onView: () {
                          // TODO
                          // open submitted file
                        },
                      )
                    : Column(
                        children: [
                          AssignmentDropzone(
                            enabled: !isClosed,
                            selectedFileName: _selectedFileName,
                            onTap: _pickFile,
                          ),
                          if (isClosed)
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.red.shade200,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Submission deadline has passed. This assignment is closed.',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_selectedFileName != null && !isClosed)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO
                                    // submit assignment
                                  },
                                  icon: const Icon(
                                    Icons.cloud_upload,
                                  ),
                                  label: const Text(
                                    'Submit Assignment',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
