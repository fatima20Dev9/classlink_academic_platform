import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_course_controller.dart';
import '../../shared/widgets/add_course_widgets/add_course_form.dart';

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Always re-create so edit/create arguments hydrate fresh state.
    if (Get.isRegistered<AddCourseController>()) {
      Get.delete<AddCourseController>(force: true);
    }
    final AddCourseController controller = Get.put(AddCourseController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          controller.pageTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1B4B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Obx(
        () => Stack(
          children: [
            AddCourseForm(
              formKey: controller.formKey,
              isLoading: controller.isLoading.value,
              onSubmit: controller.submit,
            ),
            if (controller.isLoading.value)
              const ColoredBox(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
