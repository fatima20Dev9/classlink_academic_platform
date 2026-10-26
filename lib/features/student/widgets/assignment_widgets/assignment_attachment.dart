import 'package:flutter/material.dart';

class AssignmentAttachment extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback? onTap;

  const AssignmentAttachment({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: Colors.blue[700],
              size: 28,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[700],
                    ),
                  ),

                  Text(
                    fileSize,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.file_download_outlined,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}