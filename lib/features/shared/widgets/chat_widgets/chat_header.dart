import 'package:classlink_academic_platform/features/shared/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import '../../../../widgets/user_avatar.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatController controller;

  const ChatHeader({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Obx( (){
      return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E1B4B),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            UserAvatar(
              name: controller.currentChatUserName.value,
              photoUrl: controller.currentChatUserPhoto.value,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.currentChatUserName.value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  if (controller.currentChatUserRole.value.isNotEmpty)
                    Text(
                      controller.currentChatUserRole.value,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
    );
    },
    );
  }
}
