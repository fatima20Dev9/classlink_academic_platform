import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/course_details_model.dart';
import '../../screens/course_offering.dart';

class EnrolledCourseCard extends StatelessWidget {
  final CourseDetailsViewModel course;

  const EnrolledCourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.to(
          () => CourseOfferingPage(
            data: course,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.courseName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    course.instructorName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: course.fullSemester,
                ),
                _InfoChip(
                  icon: Icons.menu_book_outlined,
                  label: '${course.credits} Credits',
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress'),
                Text(
                  '${(course.progressValue * 100).round()}%',
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: course.progressValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF4F46E5),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF312E81),
                ),
          ),
        ],
      ),
    );
  }
}