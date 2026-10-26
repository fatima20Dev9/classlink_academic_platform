import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/auth/controllers/session_controller.dart';
import '../../../../models/app_notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final VoidCallback? onTap;
  final bool compact;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uid = Get.isRegistered<SessionController>()
        ? Get.find<SessionController>().uid ?? ''
        : '';
    final unread = uid.isNotEmpty && !notification.isReadBy(uid);

    final accent = _typeColor(notification.type, theme);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(compact ? 10 : 14),
          decoration: BoxDecoration(
            color: unread
                ? accent.withOpacity(0.06)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unread
                  ? accent.withOpacity(0.35)
                  : theme.dividerColor.withOpacity(0.4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _mapIcon(notification.type),
                  color: accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: unread
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: compact ? 13 : 14,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (notification.courseName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        notification.courseName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Chip(
                          label: _typeLabel(notification.type),
                          color: accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatTime(notification.createdAt.toDate()),
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _mapIcon(String type) {
    switch (type) {
      case 'assignment':
        return Icons.assignment_outlined;
      case 'lecture':
        return Icons.menu_book_outlined;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'exam':
        return Icons.quiz_outlined;
      case 'announcement':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  static Color _typeColor(String type, ThemeData theme) {
    switch (type) {
      case 'assignment':
        return Colors.orange;
      case 'lecture':
        return Colors.blue;
      case 'chat':
        return Colors.green;
      case 'exam':
        return Colors.purple;
      case 'announcement':
        return Colors.teal;
      default:
        return theme.colorScheme.primary;
    }
  }

  static String _typeLabel(String type) {
    if (type.isEmpty) return 'General';
    return type[0].toUpperCase() + type.substring(1);
  }

  static String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
