import 'package:flutter/material.dart';

import '../../../../models/wrappers/assignment_with_submission.dart';

import 'assignment_attachment.dart';
import 'assignment_status_badge.dart';
import 'assignment_submission_section.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentWithSubmission item;

  const AssignmentCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          width: .3,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.assignment.title,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Colors.blueGrey[800],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          AssignmentStatusBadge(
                            status: item.assignment
                                    .isClosed
                                ? 'Closed'
                                : 'Active',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 5),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Due Date",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          item.assignment.dueDateText,
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 11,
                            color:
                                Colors.blueGrey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  item.assignment.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                AssignmentAttachment(
                  fileName:
                      item.assignment.attachmentName,
                  fileSize:
                      item.assignment.attachmentSize,
                  onTap: () {},
                ),
              ],
            ),
          ),

          AssignmentSubmissionSection(
            item: item,
          ),
        ],
      ),
    );
  }
}