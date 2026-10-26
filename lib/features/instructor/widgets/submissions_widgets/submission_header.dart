import 'package:flutter/material.dart';

class SubmissionHeader extends StatelessWidget {
  final String title;
  final int maxGrade;
  final VoidCallback? onBack;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SubmissionHeader({
    super.key,
    required this.title,
    required this.maxGrade,
    this.onBack,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1B4B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW (Back + Actions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                ),
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white24,
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          /// MAX GRADE BADGE
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  "$maxGrade points",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.grade,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}