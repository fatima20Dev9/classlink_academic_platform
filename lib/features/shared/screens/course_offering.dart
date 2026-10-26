import 'package:get/get.dart';
import 'package:flutter/material.dart';
// models
import '../../../models/course_details_model.dart';
// controllers
import '../../../features/auth/controllers/session_controller.dart';
// tabs
import '../widgets/course_offering_widgets/tabs/course_tab_views.dart';
import '../widgets/course_offering_widgets/tabs/tabs.dart';
// widgets
import '../widgets/course_offering_widgets/course_header.dart';
import '../widgets/course_offering_widgets/leave_course_button.dart';
import '../widgets/course_offering_widgets/sliver_tab_delegate.dart';

class CourseOfferingPage extends StatelessWidget {
  final SessionController session = Get.find<SessionController>();
  final CourseDetailsViewModel data;

  CourseOfferingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final role = session.role;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: CourseHeader(role: role, data: data),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: SliverTabBarDelegate(
                  CourseTabs.bar,
                  ),
                ),
              ];
            },
            body: CourseTabViews(
              role: role,
              data: data,
            ),
          ),
          bottomNavigationBar: const LeaveCourseButton()),
    );
  }
}
