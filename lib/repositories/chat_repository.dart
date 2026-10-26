import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _chatCollection => _firestore.collection('chats');

  CollectionReference get _userCollection => _firestore.collection('users');

  // ======================================================
  // CREATE OR GET CHAT (ONE CHAT PER PAIR OF USERS)
  // ======================================================
  Future<String> createOrGetChat({
    required String user1Id,
    required String user2Id,
    required String courseOfferingId,
  }) async {
    final ids = [user1Id, user2Id]..sort();
    final chatId = ids.join('_');

    final chatRef = _chatCollection.doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'sharedCourseOfferingIds': [courseOfferingId],
        'participants': ids,
        'lastMessage': '',
        'lastSenderId': '',
        'lastMessageTime': Timestamp.now(),
        'createdAt': Timestamp.now(),
        'isGroup': false,
      });
    } else {
      final data = chatDoc.data() as Map<String, dynamic>;
      final courses = List<String>.from(
        data['sharedCourseOfferingIds'] ?? [],
      );
      if (!courses.contains(courseOfferingId)) {
        courses.add(courseOfferingId);
        await chatRef.update({
          'sharedCourseOfferingIds': courses,
        });
      }
    }

    return chatId;
  }

  // ======================================================
  // GROUP CHATS (per Course Offering)
  // ======================================================

  String groupChatIdFor(String courseOfferingId) => 'group_$courseOfferingId';

  /// Create the group chat for a course offering if missing,
  /// or refresh its name / ensure instructor membership.
  Future<String> createGroupChatForOffering({
    required String courseOfferingId,
    required String groupName,
    required List<String> memberIds,
  }) async {
    final chatId = groupChatIdFor(courseOfferingId);
    final chatRef = _chatCollection.doc(chatId);
    final doc = await chatRef.get();

    final uniqueMembers = memberIds.toSet().toList();

    if (!doc.exists) {
      await chatRef.set({
        'isGroup': true,
        'groupName': groupName,
        'courseOfferingId': courseOfferingId,
        'sharedCourseOfferingIds': [courseOfferingId],
        'participants': uniqueMembers,
        'lastMessage': '',
        'lastSenderId': '',
        'lastMessageTime': Timestamp.now(),
        'createdAt': Timestamp.now(),
      });
    } else {
      await chatRef.update({
        'groupName': groupName,
        'isGroup': true,
        'courseOfferingId': courseOfferingId,
        'participants': FieldValue.arrayUnion(uniqueMembers),
      });
    }

    return chatId;
  }

  /// Add a single user to a course offering's group chat
  /// (no-op if the chat does not exist yet).
  Future<void> addMemberToGroupChat({
    required String courseOfferingId,
    required String userId,
  }) async {
    final chatId = groupChatIdFor(courseOfferingId);
    final chatRef = _chatCollection.doc(chatId);
    final doc = await chatRef.get();
    if (!doc.exists) return;

    await chatRef.update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // ======================================================
  // SEND MESSAGE
  // ======================================================
  Future<void> sendMessage({
    required MessageModel message,
  }) async {
    final messageRef =
        _chatCollection.doc(message.chatId).collection('messages').doc();

    final data = message.copyWith(id: messageRef.id);

    await messageRef.set(data.toJson());

    await _chatCollection.doc(message.chatId).update({
      'lastMessage': message.content,
      'lastSenderId': message.senderId,
      'lastMessageTime': Timestamp.now(),
    });
  }

  // ======================================================
  // STREAM MESSAGES (REALTIME)
  // ======================================================
  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // ======================================================
  // STREAM CHATS FOR USER
  // ======================================================
  Stream<List<ChatModel>> streamChats(String currentUserId) {
    return _chatCollection
        .where(
          'participants',
          arrayContains: currentUserId,
        )
        .orderBy(
          'lastMessageTime',
          descending: true,
        )
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatModel> chats = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final participants = List<String>.from(data['participants'] ?? const []);
        final base = ChatModel.fromJson(data, doc.id);

        // Group chats: skip other-user lookup, use group name as display.
        if (base.isGroup) {
          chats.add(
            base.copyWith(
              otherUserId: '',
              otherUserName: base.groupName,
              otherUserPhoto: '',
              otherUserRole: 'group',
            ),
          );
          continue;
        }

        final others = participants
            .where(
              (id) => id != currentUserId,
            )
            .toList();
        if (others.isEmpty) {
          debugPrint("Invalid chat ${doc.id}: participants = $participants");
          continue;
        }
        final otherUserId = others.first;

        final userDoc = await _userCollection.doc(otherUserId).get();
        final user = (userDoc.data() as Map<String, dynamic>?) ?? {};

        chats.add(
          base.copyWith(
            otherUserId: otherUserId,
            otherUserName: user['name'] ?? '',
            otherUserPhoto: user['photoUrl'] ?? '',
            otherUserRole: user['role'] ?? '',
          ),
        );
      }

      return chats;
    });
  }

  // ======================================================
  // GET SINGLE CHAT
  // ======================================================
  Future<ChatModel?> getChat(String chatId) async {
    final doc = await _chatCollection.doc(chatId).get();

    if (!doc.exists) return null;

    return ChatModel.fromJson(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  // ======================================================
  // MARK AS READ
  // ======================================================
  Future<void> markAsRead({
    required String chatId,
    required String userId,
  }) async {
    final messages = await _chatCollection
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();

    for (final doc in messages.docs) {
      batch.update(doc.reference, {
        'isRead': true,
      });
    }

    await batch.commit();
  }
}
