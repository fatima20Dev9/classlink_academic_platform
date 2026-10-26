import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';

import '../widgets/home_widgets/home_drawer.dart';
import '../widgets/home_widgets/home_header.dart';
import '../widgets/home_widgets/home_courses_list.dart';
import '../widgets/home_widgets/quick_actions_grid.dart';
import '../widgets/home_widgets/section_header.dart';
import '../widgets/home_widgets/notification_list.dart';

import '../screens/all_enrolled_courses.dart';
import '../screens/notifications_screen.dart';

class HomePage extends StatelessWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController(role: role));
    final notificationController =
        Get.put(NotificationController(), permanent: true);

    void openNotifications() {
      Get.to(() => const NotificationsScreen());
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: HomeDrawer(role: role),
      body: SafeArea(
        child: Obx(() {
          if (homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeController.errorMessage.isNotEmpty) {
            return Center(child: Text(homeController.errorMessage.value));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await homeController.refreshCourses();
              await notificationController.loadNotifications();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// HEADER (bell with badge)
                  HomeHeader(
                    role: role,
                    onBellTap: openNotifications,
                  ),

                  const SizedBox(height: 24),

                  /// COURSES
                  SectionHeader(
                    title: 'My Courses',
                    actionText: 'See All',
                    onPressed: () {
                      Get.to(() => const AllEnrolledCoursesPage(
                            showAppBar: true,
                          ));
                    },
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (homeController.courses.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No courses available')),
                      );
                    }
                    return HomeCoursesList(
                      courses: homeController.courses,
                      role: role,
                    );
                  }),

                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  QuickActionsGrid(
                    isStudent: role.toLowerCase() == 'student',
                  ),

                  const SizedBox(height: 24),

                  /// NOTIFICATIONS (latest 10)
                  SectionHeader(
                    title: 'Notifications',
                    actionText: 'See All',
                    onPressed: openNotifications,
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (notificationController.isLoading.value &&
                        notificationController.notifications.isEmpty) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (notificationController.error.isNotEmpty &&
                        notificationController.notifications.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          notificationController.error.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    final latest = notificationController.latest10;
                    if (latest.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No notifications'),
                      );
                    }
                    return NotificationListWidget(
                      notifications: latest,
                      compact: true,
                      onTap: (n) {
                        notificationController.markAsRead(n);
                        openNotifications();
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
