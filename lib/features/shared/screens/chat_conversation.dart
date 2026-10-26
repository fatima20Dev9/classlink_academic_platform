import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/controllers/chat_controller.dart';
// import '../../../models/message_model.dart';
import '../../../features/shared/widgets/chat_widgets/chat_message_bubble.dart';
import '../../../features/shared/widgets/chat_widgets/chat_header.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({super.key});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // يبدأ الاستماع للرسائل عند فتح الصفحة
    // controller.refreshMessages();
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    controller.sendMessage(text);

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),

      // ================= APP BAR =================
      appBar: ChatHeader(
        controller: controller,
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= MESSAGES =================
          Expanded(
            child: Obx(() {
              final messages = controller.messages;

              if (messages.isEmpty) {
                return const Center(
                  child: Text("No messages yet"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  final isMe = msg.senderId == controller.session.uid;

                  return MessageBubble(
                    message: msg,
                    isMe: isMe,
                  );
                },
              );
            }),
          ),

          // ================= INPUT =================
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: const Color(0xffF3F6FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1B4B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.stopListeningMessages();
    super.dispose();
  }
}