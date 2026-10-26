import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/enrolled_courses_controller.dart';
import '/features/shared/widgets/all_enrolled_courses_widgets/enrolled_courses_header.dart';
import '/features/shared/widgets/all_enrolled_courses_widgets/enrolled_courses_list.dart';
import '/features/shared/widgets/all_enrolled_courses_widgets/courses_loading_view.dart';
import '/features/shared/widgets/all_enrolled_courses_widgets/empty_courses_view.dart';

class AllEnrolledCoursesPage extends StatelessWidget {
  final bool showAppBar;

  const AllEnrolledCoursesPage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnrolledCoursesController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// =========================
      /// APP BAR (Same design)
      /// =========================
      appBar: showAppBar ? AppBar() : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CoursesLoadingView();
        }

        if (controller.isEmpty) {
          return const EmptyCoursesView();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshCourses,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              /// =========================
              /// HEADER (pinned style alternative)
              /// =========================
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    10,
                  ),
                  child: const EnrolledCoursesHeader(),
                ),
              ),

              /// =========================
              /// LIST
              /// =========================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: EnrolledCoursesList(
                      // courses: controller.courses,
                      ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
