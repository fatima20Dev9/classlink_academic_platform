import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';


class HomeHeader extends StatelessWidget {
  final String role;
  final VoidCallback? onBellTap;

  const HomeHeader({
    super.key,
    required this.role,
    this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    final isStudent = role == 'student';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    // child: Text(
                    //   'Hello ${isStudent ? 'Student' : 'Instructor'}',
                    //   overflow: TextOverflow.ellipsis,
                    //   style: const TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    child: Text(
                      'ClassLink',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isStudent ? 'Student View' : 'Instructor View',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[800]),
                ),
              ),
            ],
          ),
        ),
        const _NotificationBell(),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    // Use the existing parent's onBellTap via lookup.
    final parent =
        context.findAncestorWidgetOfExactType<HomeHeader>();
    final onTap = parent?.onBellTap;

    final ctrl = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController(), permanent: true);

    return Obx(() {
      // touch reactive sources
      ctrl.notifications.length;
      final count = ctrl.unreadCount;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              size: 28,
            ),
            onPressed: onTap,
          ),
          if (count > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
