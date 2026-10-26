import 'package:flutter/material.dart';

class EnrolledCoursesHeader extends StatelessWidget {
  const EnrolledCoursesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// =========================
        /// TITLE
        /// =========================
        Text(
          'All Courses',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 6),

        /// =========================
        /// SUBTITLE
        /// =========================
        Text(
          'Track your active courses, progress, and semester details.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}