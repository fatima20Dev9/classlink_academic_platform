import 'package:flutter/material.dart';
import '../../../../models/course_details_model.dart';
import 'home_course_card.dart';

class HomeCoursesList extends StatelessWidget {
  final List<CourseDetailsViewModel> courses;
  final String role;

  const HomeCoursesList({
    super.key,
    required this.courses,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('No courses available')),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = courses[index];

          return HomeCourseCard(course: course, isInstructor: role == 'instructor',);
        },
      ),
    );
  }
}
