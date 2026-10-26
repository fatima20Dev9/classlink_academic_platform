import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/assignment_model.dart';
import '../../../instructor/screens/submission.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const AssignmentCard({
    super.key,
    required this.assignment,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final a = assignment;
    // final bool isClosed = DateTime.now().isAfter(a.dueDate.toDate());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Expanded(
                child: Text(
                  a.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: assignment.isClosed
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  assignment.isClosed ? 'Closed' : 'Active',
                  style: TextStyle(
                    color: assignment.isClosed
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  }

                  if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 8),

          /// DESCRIPTION
          Text(
            a.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 12),

          /// DUE DATE
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text(
                a.dueDate.toDate().toString().split(" ")[0],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// VIEW SUBMISSIONS
          InkWell(
            onTap: () {
              Get.to(() => SubmissionPage(
                    assignment: {
                      'id': a.id,
                      'title': a.title,
                    },
                  ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View Submissions",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
