import 'package:flutter/material.dart';

class AssignmentDropzone extends StatelessWidget {
  final VoidCallback? onTap;
  final String? selectedFileName;
  final bool enabled;

  const AssignmentDropzone({
    super.key,
    this.onTap,
    this.selectedFileName,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFileName != null && selectedFileName!.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                enabled ? Colors.blue.withOpacity(0.4) : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: enabled
              ? Colors.blue.shade50.withOpacity(0.3)
              : Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!enabled) ...[
              const Text(
                'Submission Closed',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Icon(
              hasFile
                  ? Icons.check_circle_outline
                  : Icons.cloud_upload_outlined,
              color: !enabled
                  ? Colors.grey
                  : hasFile
                      ? Colors.green
                      : Colors.blue.shade600,
              size: 36,
            ),
            const SizedBox(height: 10),
            if (hasFile) ...[
              Text(
                selectedFileName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap to choose another file',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ] else ...[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Drop your file here or ',
                    ),
                    TextSpan(
                      text: 'click to browse',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Accepted formats: PDF, DOC, DOCX, ZIP (Max 50MB)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
