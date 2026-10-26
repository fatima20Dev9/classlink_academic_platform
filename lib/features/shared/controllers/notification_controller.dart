import 'dart:async';

import 'package:get/get.dart';

import '../../../models/app_notification_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../auth/controllers/session_controller.dart';

/// Real-time notification state for the signed-in user.
///
/// Backed by a Firestore stream — `notifications`, `latest10` and
/// `unreadCount` all update automatically.
class NotificationController extends GetxController {
  final SessionController _session = Get.find<SessionController>();
  final NotificationRepository _repo =
      Get.find<NotificationRepository>();

  final RxList<AppNotificationModel> notifications =
      <AppNotificationModel>[].obs;

  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  StreamSubscription<List<AppNotificationModel>>? _sub;

  /// Latest 10 (for the home page section).
  List<AppNotificationModel> get latest10 =>
      notifications.take(10).toList();

  /// Count of unread notifications for the current user.
  int get unreadCount {
    final uid = _session.uid;
    if (uid == null || uid.isEmpty) return 0;
    return notifications.where((n) => !n.isReadBy(uid)).length;
  }

  @override
  void onInit() {
    super.onInit();
    _start();
    // Re-subscribe when the signed-in user changes.
    ever<dynamic>(_session.currentUser, (_) => _start());
  }

  void _start() {
    _sub?.cancel();
    final uid = _session.uid;
    if (uid == null || uid.isEmpty) {
      notifications.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    error.value = '';

    _sub = _repo.streamForUser(uid).listen(
      (data) {
        notifications.assignAll(data);
        isLoading.value = false;
      },
      onError: (Object e) {
        error.value = e.toString();
        isLoading.value = false;
      },
    );
  }

  /// One-shot reload (used by RefreshIndicator).
  Future<void> loadNotifications() async {
    final uid = _session.uid;
    if (uid == null || uid.isEmpty) {
      notifications.clear();
      return;
    }
    try {
      isLoading.value = true;
      final data = await _repo.fetchForUser(uid);
      notifications.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(AppNotificationModel n) async {
    final uid = _session.uid;
    if (uid == null || uid.isEmpty) return;
    if (n.isReadBy(uid)) return;
    try {
      await _repo.markAsRead(n.id, uid);
    } catch (_) {
      // ignore — UI keeps working from the stream.
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
