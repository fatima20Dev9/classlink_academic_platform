import 'package:flutter/material.dart';

import 'required_course_fields.dart';
import 'optional_course_fields.dart';
import 'grade_breakdown_section.dart';
import 'submit_course_button.dart';

class AddCourseForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onSubmit;

  const AddCourseForm({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /// =========================
            /// REQUIRED FIELDS
            /// =========================

            const Text(
              'Required Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const RequiredCourseFields(),

            const SizedBox(height: 24),

            /// =========================
            /// OPTIONAL FIELDS
            /// =========================

            const Text(
              'Optional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const OptionalCourseFields(),

            const SizedBox(height: 24),

            /// =========================
            /// GRADE BREAKDOWN
            /// =========================

            const GradeBreakdownSection(),

            const SizedBox(height: 32),

            /// =========================
            /// SUBMIT
            /// =========================

            SubmitCourseButton(
              isLoading: isLoading,
              onPressed: onSubmit,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}