import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_course_controller.dart';
import 'number_input_field.dart';
import 'text_input_field.dart';

class RequiredCourseFields extends StatelessWidget {
  const RequiredCourseFields({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddCourseController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Course Name',
            hint: 'e.g. Data Structures',
            enabled: !c.isLoading.value,
            initialValue: c.courseName.value,
            onChanged: (value) => c.courseName.value = value,
          ),
          const SizedBox(height: 12),
          TextInputField(
            label: 'Instructor',
            hint: 'e.g. Dr. Ahmed',
            enabled: !c.isLoading.value,
            initialValue: c.instructorName.value,
            onChanged: (value) => c.instructorName.value = value,
          ),
          const SizedBox(height: 12),
          TextInputField(
            label: 'Semester',
            hint: 'e.g. Fall 2026',
            enabled: !c.isLoading.value,
            initialValue: c.semester.value,
            onChanged: (value) => c.semester.value = value,
          ),
          const SizedBox(height: 12),
          NumberInputField(
            label: 'Credits',
            hint: '3',
            enabled: !c.isLoading.value,
            initialValue: c.credits.value,
            onChanged: (value) => c.credits.value = value,
          ),
        ],
      ),
    );
  }
}
