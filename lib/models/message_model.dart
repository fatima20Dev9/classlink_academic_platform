import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  file,
}

class MessageModel {
  final String id;

  /// معرف المحادثة
  final String chatId;

  /// المرسل
  final String senderId;

  /// محتوى الرسالة (نص أو رابط)
  final String content;

  /// نوع الرسالة
  final MessageType type;

  /// وقت الإرسال
  final Timestamp createdAt;

  /// هل تم قراءة الرسالة
  final bool isRead;

  /// (اختياري للمستقبل: اسم المرسل لتقليل الاستعلامات)
  final String? senderName;

  /// (اختياري: صورة الملف/الصورة)
  final String? mediaUrl;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.senderName,
    this.mediaUrl,
  });

  // =========================
  // FROM FIRESTORE
  // =========================
  factory MessageModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return MessageModel(
      id: docId,
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      type: _parseType(json['type']),
      createdAt: json['createdAt'] ?? Timestamp.now(),
      isRead: json['isRead'] ?? false,
      senderName: json['senderName'],
      mediaUrl: json['mediaUrl'],
    );
  }

  // =========================
  // TO FIRESTORE
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'createdAt': createdAt,
      'isRead': isRead,
      'senderName': senderName,
      'mediaUrl': mediaUrl,
    };
  }

  // =========================
  // TYPE PARSER
  // =========================
  static MessageType _parseType(dynamic value) {
    switch (value) {
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      default:
        return MessageType.text;
    }
  }

  // =========================
  // COPY WITH
  // =========================
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    MessageType? type,
    Timestamp? createdAt,
    bool? isRead,
    String? senderName,
    String? mediaUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      senderName: senderName ?? this.senderName,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }
}