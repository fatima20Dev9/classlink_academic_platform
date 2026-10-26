import 'package:flutter/material.dart';

class EmptyCoursesView extends StatelessWidget {
  const EmptyCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// =========================
            /// ICON
            /// =========================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            /// =========================
            /// TITLE
            /// =========================
            Text(
              'No Enrolled Courses',
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            /// =========================
            /// DESCRIPTION
            /// =========================
            Text(
              'You are not enrolled in any courses yet. '
              'Once you join a course, it will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            /// =========================
            /// OPTIONAL ACTION (future use)
            /// =========================
            // TextButton(
            //   onPressed: () {},
            //   child: const Text('Explore Courses'),
            // ),
          ],
        ),
      ),
    );
  }
}