import 'package:classlink_academic_platform/features/shared/controllers/all_assignments_controller.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../../../student/screens/schedule_lectures.dart';
import '../../../shared/screens/add_course.dart';
import '../../screens/join_course_by_code.dart';
import '../../screens/all_assignments.dart';

class QuickActionsGrid extends StatelessWidget {
  final bool isStudent;

  const QuickActionsGrid({
    super.key,
    required this.isStudent,
  });

  void _handleTap(BuildContext context, String action) {
    switch (action) {
      case 'join_course':
        Get.put(AllAssignmentsController());

        Get.to(() => const JoinCourseByCodePage());
        break;

      case 'studentTasks':
        Get.put(AllAssignmentsController());

        Get.to(
          () => const AllAssignmentsPage(
            isStudent: true,
          ),
        );
        break;

      case 'schedule':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LectureSchedulePage(),
          ),
        );
        break;

      case 'results':
        // TODO: ResultsPage
        break;

      case 'create_course':
        Get.to(() => const AddCoursePage());
        break;

      case 'instructorTasks':
        Get.to(
          () => const AllAssignmentsPage(
            isStudent: false,
          ),
        );
        break;

      case 'report':
        // TODO: ReportsPage
        break;

      case 'exams':
        // TODO: ExamsManagementPage
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = isStudent
        ? [
            {
              'key': 'join_course',
              'icon': Icons.library_add_outlined,
              'label': 'Join Course',
              'color': Colors.blue,
            },
            {
              'key': 'studentTasks',
              'icon': Icons.assignment_outlined,
              'label': 'Tasks',
              'color': Colors.orange,
            },
            {
              'key': 'schedule',
              'icon': Icons.schedule_outlined,
              'label': 'Schedule',
              'color': Colors.green,
            },
            {
              'key': 'results',
              'icon': Icons.bar_chart,
              'label': 'Results',
              'color': Colors.purple,
            },
          ]
        : [
            {
              'key': 'create_course',
              'icon': Icons.library_add_outlined,
              'label': 'Create Course',
              'color': Colors.blue,
            },
            {
              'key': 'instructorTasks',
              'icon': Icons.assignment_outlined,
              'label': 'Tasks',
              'color': Colors.orange,
            },
            {
              'key': 'report',
              'icon': Icons.assessment_outlined,
              'label': 'Report',
              'color': Colors.green,
            },
            {
              'key': 'exams',
              'icon': Icons.edit_calendar,
              'label': 'Exams',
              'color': Colors.purple,
            },
          ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        const count = 4;

        final itemWidth =
            (constraints.maxWidth - spacing * (count - 1)) / count;

        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: GestureDetector(
                onTap: () => _handleTap(context, action['key'] as String),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
