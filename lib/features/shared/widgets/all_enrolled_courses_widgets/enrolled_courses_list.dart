import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/enrolled_courses_controller.dart';
import 'courses_loading_view.dart';
import 'empty_courses_view.dart';
import 'enrolled_course_card.dart';

class EnrolledCoursesList extends GetView<EnrolledCoursesController> {
  const EnrolledCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
  "LIST COURSES = ${controller.courses.length}",
);
      /// =========================
      /// LOADING
      /// =========================
      if (controller.isLoading.value) {
        return const CoursesLoadingView();
      }

      /// =========================
      /// ERROR
      /// =========================
      if (controller.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchCourses,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      /// =========================
      /// EMPTY
      /// =========================
      if (controller.isEmpty) {
        return const EmptyCoursesView();
      }

      /// =========================
      /// LIST (FIXED: Sliver instead of ListView)
      /// =========================
      return RefreshIndicator(
        onRefresh: controller.refreshCourses,
        child: ListView.separated(
          shrinkWrap: true, // ✅ مهم جدًا
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.courses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            final course = controller.courses[index];

            return EnrolledCourseCard(
  course: course,
);
          },
        ),
      );
    });
  }
}
