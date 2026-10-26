import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_course_controller.dart';

class SubmitCourseButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitCourseButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddCourseController>();

    return Obx(() {
      final isLoading = c.isLoading.value;
      final isValid = c.isFormValid;

      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: (!isValid || isLoading) ? null : () => c.submit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  c.submitLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }
}
