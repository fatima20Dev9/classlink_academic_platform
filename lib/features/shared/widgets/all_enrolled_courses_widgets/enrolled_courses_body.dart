import 'package:flutter/material.dart';

import 'enrolled_courses_header.dart';
import 'enrolled_courses_list.dart';

class EnrolledCoursesBody extends StatelessWidget {
  const EnrolledCoursesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================
          /// HEADER
          /// =========================
          const Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              16,
            ),
            child: EnrolledCoursesHeader(),
          ),

          /// =========================
          /// COURSES LIST
          /// =========================
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: EnrolledCoursesList(),
            ),
          ),
        ],
      ),
    );
  }
}