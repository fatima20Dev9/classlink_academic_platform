import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_course_controller.dart';
import 'number_input_field.dart';
import 'text_input_field.dart';

class OptionalCourseFields extends StatelessWidget {
  const OptionalCourseFields({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddCourseController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          TextInputField(
            label: 'Course Overview',
            hint: 'Short description of the course',
            maxLines: 3,
            enabled: !c.isLoading.value,
            initialValue: c.overview.value,
            onChanged: (value) => c.overview.value = value,
          ),
          const SizedBox(height: 12),
          TextInputField(
            label: 'Day & Time',
            hint: 'Mon & Wed - 10:00 AM',
            enabled: !c.isLoading.value,
            initialValue: c.dayTime.value,
            onChanged: (value) => c.dayTime.value = value,
          ),
          const SizedBox(height: 12),
          NumberInputField(
            label: 'Lectures per Semester',
            hint: '24',
            enabled: !c.isLoading.value,
            initialValue: c.lectures.value,
            onChanged: (value) => c.lectures.value = value,
          ),
          const SizedBox(height: 12),
          NumberInputField(
            label: 'Hours per Week',
            hint: '3',
            enabled: !c.isLoading.value,
            initialValue: c.hoursPerWeek.value,
            onChanged: (value) => c.hoursPerWeek.value = value,
          ),
        ],
      ),
    );
  }
}
