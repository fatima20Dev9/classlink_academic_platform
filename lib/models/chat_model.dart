import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  /// Document ID (uid1_uid2 for 1:1, group_<offeringId> for group)
  final String id;

  /// المشاركون
  final List<String> participants;

  /// آخر رسالة
  final String lastMessage;

  /// مرسل آخر رسالة
  final String lastSenderId;

  /// وقت آخر رسالة
  final Timestamp lastMessageTime;

  /// تاريخ إنشاء المحادثة
  final Timestamp createdAt;
  final List<String> sharedCourseOfferingIds;

  /// Group chat extension
  final bool isGroup;
  final String groupName;
  final String courseOfferingId;

  final String? otherUserId;
  final String? otherUserName;
  final String? otherUserPhoto;
  final String? otherUserRole;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastMessageTime,
    required this.createdAt,
    required this.sharedCourseOfferingIds,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhoto,
    required this.otherUserRole,
    this.isGroup = false,
    this.groupName = '',
    this.courseOfferingId = '',
  });

  factory ChatModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return ChatModel(
      id: docId,
      participants: List<String>.from(
        json['participants'] ?? [],
      ),
      lastMessage: json['lastMessage'] ?? '',
      lastSenderId: json['lastSenderId'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? Timestamp.now(),
      createdAt: json['createdAt'] ?? Timestamp.now(),
      sharedCourseOfferingIds: List<String>.from(
        json['sharedCourseOfferingIds'] ?? [],
      ),
      isGroup: json['isGroup'] == true,
      groupName: json['groupName'] ?? '',
      courseOfferingId: json['courseOfferingId'] ?? '',
      otherUserId: '',
      otherUserName: '',
      otherUserPhoto: '',
      otherUserRole: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'sharedCourseOfferingIds': sharedCourseOfferingIds,
      'isGroup': isGroup,
      'groupName': groupName,
      'courseOfferingId': courseOfferingId,
    };
  }

  ChatModel copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    String? lastSenderId,
    Timestamp? lastMessageTime,
    Timestamp? createdAt,
    List<String>? sharedCourseOfferingIds,
    bool? isGroup,
    String? groupName,
    String? courseOfferingId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserPhoto,
    String? otherUserRole,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
      sharedCourseOfferingIds:
          sharedCourseOfferingIds ?? this.sharedCourseOfferingIds,
      isGroup: isGroup ?? this.isGroup,
      groupName: groupName ?? this.groupName,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserPhoto: otherUserPhoto ?? this.otherUserPhoto,
      otherUserRole: otherUserRole ?? this.otherUserRole,
    );
  }
}
