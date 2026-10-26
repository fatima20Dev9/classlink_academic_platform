import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/app_notification_model.dart';
import '../controllers/notification_controller.dart';
import '../widgets/home_widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty &&
            controller.notifications.isEmpty) {
          return _ErrorView(
            message: controller.error.value,
            onRetry: controller.loadNotifications,
          );
        }

        final items = controller.notifications;
        if (items.isEmpty) {
          return const _EmptyView();
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final n = items[i];
              return NotificationTile(
                notification: n,
                onTap: () => controller.markAsRead(n),
              );
            },
          ),
        );
      }),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.notifications_off_outlined,
            size: 64, color: Colors.grey),
        SizedBox(height: 12),
        Center(child: Text('No notifications yet')),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
