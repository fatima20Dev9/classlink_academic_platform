import 'package:classlink_academic_platform/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/shared/widgets/chat_widgets/search_bar.dart';
import '../../../features/shared/widgets/chat_widgets/conversation_card.dart';

import '../../../features/shared/controllers/chat_controller.dart';
// import '../../../models/chat_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController controller = Get.find<ChatController>();

  final TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    // controller.loadUserChats(); // 🔥 تحميل المحادثات الحقيقية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final chats = controller.chats;

        final filtered = chats.where((chat) {
          return (chat.otherUserName ?? '')
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
        return CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                controller: searchController,
                onChanged: (value) {
                  setState(() => query = value);
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: filtered.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text("No conversations"),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final chat = filtered[index];

                          return ConversationCardWidget(
                              name: chat.otherUserName ?? '',
                              role: chat.otherUserRole ?? '',
                              lastMessage: chat.lastMessage,
                              time: _formatTime(chat.lastMessageTime),
                              avatarUrl: chat.otherUserPhoto ?? '',
                              // "https://i.pravatar.cc/150?img=${index + 1}",
                              unreadCount: 0,
                              onTap: () async {
                                //  controller.openExistingChat(chat);
                                await controller.openExistingChat(chat);
                                Get.toNamed(AppRoutes.chatConversation);
                                // controller.openChat(
                                //   otherUserId: chat.participants.firstWhere(
                                //     (id) => id != controller.session.uid,
                                //   ),
                                //   courseOfferingId:
                                //       chat.sharedCourseOfferingIds.first, // ✅ هنا الحل
                                // );
                              });
                        },
                        childCount: filtered.length,
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  SliverAppBar _buildHeader() {
    return const SliverAppBar(
      expandedHeight: 90,
      pinned: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 50, right: 50),
        title: Text(
          "Messages",
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    try {
      final date = timestamp.toDate();
      return "${date.hour}:${date.minute}";
    } catch (e) {
      return "";
    }
  }
}
