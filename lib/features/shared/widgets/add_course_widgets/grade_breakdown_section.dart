import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_course_controller.dart';
import 'form_section_header.dart';
import 'number_input_field.dart';

class GradeBreakdownSection extends StatelessWidget {
  const GradeBreakdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddCourseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionHeader(
          title: 'Grade Breakdown (%)',
          subtitle: 'Total should equal 100%',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: NumberInputField(
                label: 'Attendance',
                hint: '10',
                initialValue: c.attendance.value,
                onChanged: (v) => c.attendance.value = v,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumberInputField(
                label: 'Assignments',
                hint: '30',
                initialValue: c.assignments.value,
                onChanged: (v) => c.assignments.value = v,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumberInputField(
                label: 'Midterm',
                hint: '60',
                initialValue: c.midterm.value,
                onChanged: (v) => c.midterm.value = v,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
