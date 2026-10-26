import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class ChatService {
  final ChatRepository _repo = Get.find<ChatRepository>();

  // ======================================================
  // CREATE OR GET CHAT
  // ======================================================
  Future<String> createOrGetChat({
    required String user1Id,
    required String user2Id,
    required String courseOfferingId,
  }) {
    return _repo.createOrGetChat(
      user1Id: user1Id,
      user2Id: user2Id,
      courseOfferingId: courseOfferingId,
    );
  }

  // ======================================================
  // GROUP CHAT
  // ======================================================
  Future<String> createGroupChatForOffering({
    required String courseOfferingId,
    required String groupName,
    required List<String> memberIds,
  }) {
    return _repo.createGroupChatForOffering(
      courseOfferingId: courseOfferingId,
      groupName: groupName,
      memberIds: memberIds,
    );
  }

  Future<void> addMemberToGroupChat({
    required String courseOfferingId,
    required String userId,
  }) {
    return _repo.addMemberToGroupChat(
      courseOfferingId: courseOfferingId,
      userId: userId,
    );
  }

  // ======================================================
  // SEND MESSAGE
  // ======================================================
  Future<void> sendMessage({
    required MessageModel message,
  }) {
    return _repo.sendMessage(
      message: message,
    );
  }

  // ======================================================
  // STREAM MESSAGES
  // ======================================================
  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _repo.streamMessages(chatId);
  }

  // ======================================================
  // STREAM USER CHATS
  // ======================================================
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _repo.streamChats(userId);
  }

  // ======================================================
  // GET SINGLE CHAT
  // ======================================================
  Future<ChatModel?> getChat(String chatId) {
    return _repo.getChat(chatId);
  }

  // ======================================================
  // MARK AS READ
  // ======================================================
  Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) {
    return _repo.markAsRead(
      chatId: chatId,
      userId: userId,
    );
  }
}
