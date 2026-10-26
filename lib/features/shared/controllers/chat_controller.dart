import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/notification_dispatcher.dart';
import '../../../features/auth/controllers/session_controller.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadUserChats();
  }

  final ChatService _service = Get.find<ChatService>();
  final SessionController _session = Get.find<SessionController>();
  SessionController get session => _session;

  final NotificationDispatcher _dispatcher =
      Get.isRegistered<NotificationDispatcher>()
          ? Get.find<NotificationDispatcher>()
          : NotificationDispatcher();

  // =========================
  // STATE
  // =========================
  final RxBool isLoading = false.obs;
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  String? currentChatId;

  StreamSubscription? _chatSub;
  StreamSubscription? _msgSub;

  final RxMap<String, Map<String, dynamic>> users =
      <String, Map<String, dynamic>>{}.obs;

  // ======================================================
  // LOAD USER CHATS (REALTIME)
  // ======================================================
  void loadUserChats() {
    final userId = _session.uid;
    if (userId == null) return;

    _chatSub?.cancel();

    _chatSub = _service.getUserChats(userId).listen((data) {
      chats.assignAll(data);
    });
  }

  // ======================================================
  // OPEN CHAT (create or get)
  // ======================================================

  final RxString currentChatUserName = ''.obs;
  final RxString currentChatUserPhoto = ''.obs;
  final RxString currentChatUserRole = ''.obs;

  Future<void> openChat({
    required String otherUserId,
    required String courseOfferingId,
  }) async {
    final userId = _session.uid;
    if (userId == null) return;

    isLoading.value = true;

    try {
      currentChatId = await _service.createOrGetChat(
        user1Id: userId,
        user2Id: otherUserId,
        courseOfferingId: courseOfferingId,
      );
      final user = await getUser(otherUserId);

      currentChatUserName.value = user['name'] ?? '';
      currentChatUserPhoto.value = user['photoUrl'] ?? '';
      currentChatUserRole.value = user['role'] ?? '';

      _listenMessages();
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // LISTEN MESSAGES REALTIME
  // ======================================================
  void _listenMessages() {
    if (currentChatId == null) return;

    _msgSub?.cancel();

    _msgSub = _service.streamMessages(currentChatId!).listen((data) {
      messages.assignAll(data);
    });
  }

  // ======================================================
  // SEND MESSAGE
  // ======================================================
  Future<void> sendMessage(String text) async {
    final userId = _session.uid;
    if (userId == null || currentChatId == null) return;

    if (text.trim().isEmpty) return;

    final message = MessageModel(
      id: '',
      chatId: currentChatId!,
      senderId: userId,
      content: text.trim(),
      type: MessageType.text,
      createdAt: Timestamp.now(),
      isRead: false,
    );

    await _service.sendMessage(message: message);

    // Notify the other chat participant(s).
    try {
      final chat = await _service.getChat(currentChatId!);
      final participants =
          chat?.participants ?? _participantsFromChatId(currentChatId!, userId);
      final senderName =
          (_session.currentUser.value?.name ?? '').toString();
      final courseOfferingId =
          (chat?.sharedCourseOfferingIds.isNotEmpty ?? false)
              ? chat!.sharedCourseOfferingIds.first
              : '';
      // ignore: unawaited_futures
      _dispatcher.chatMessageSent(
        chatId: currentChatId!,
        senderId: userId,
        senderName: senderName,
        participants: participants,
        preview: text.trim(),
        courseOfferingId: courseOfferingId,
      );
    } catch (_) {
      // swallow
    }
  }

  List<String> _participantsFromChatId(String chatId, String selfId) {
    final parts = chatId.split('_');
    if (parts.length >= 2) return parts;
    return [selfId];
  }

  // ======================================================
  // MARK AS READ
  // ======================================================
  Future<void> markAsRead() async {
    final userId = _session.uid;
    if (userId == null || currentChatId == null) return;

    await _service.markAsRead(
      chatId: currentChatId!,
      userId: userId,
    );
  }
  // ======================================================
  // GET USERS NAMES
  // ======================================================

  Future<Map<String, dynamic>> getUser(String uid) async {
    if (users.containsKey(uid)) {
      return users[uid]!;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final data = doc.data()!;

    users[uid] = data;

    return data;
  }

  Future<void> openExistingChat(ChatModel chat) async {
    currentChatId = chat.id;

    currentChatUserName.value = chat.otherUserName ?? '';
    currentChatUserPhoto.value = chat.otherUserPhoto ?? '';
    currentChatUserRole.value = chat.otherUserRole ?? '';

    _listenMessages();

    await markAsRead();
  }

  // ======================================================
  // CLEAN UP
  // ======================================================
  @override
  void onClose() {
    _chatSub?.cancel();
    _msgSub?.cancel();
    super.onClose();
  }

  void stopListeningMessages() {
    _msgSub?.cancel();
    _msgSub = null;
    currentChatId = null;
    messages.clear();

    currentChatUserName.value = '';
    currentChatUserPhoto.value = '';
    currentChatUserRole.value = '';
  }
}
