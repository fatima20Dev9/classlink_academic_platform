import 'package:flutter/material.dart';

import '../../../../models/app_notification_model.dart';
import 'notification_tile.dart';

class NotificationListWidget extends StatelessWidget {
  final List<AppNotificationModel> notifications;
  final bool compact;
  final void Function(AppNotificationModel n)? onTap;

  const NotificationListWidget({
    super.key,
    required this.notifications,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No notifications'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final n = notifications[i];
        return NotificationTile(
          notification: n,
          compact: compact,
          onTap: onTap == null ? null : () => onTap!(n),
        );
      },
    );
  }
}
