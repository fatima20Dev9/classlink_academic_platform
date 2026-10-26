import 'package:classlink_academic_platform/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/people_controller.dart';
import '../controllers/chat_controller.dart';
import '../../../widgets/user_avatar.dart';

class PeoplePage extends StatefulWidget {
  final String courseOfferingId;

  const PeoplePage({
    super.key,
    required this.courseOfferingId,
  });

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final PeopleController controller = Get.find<PeopleController>();
  // late final PeopleController controller;
  // List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();

    // controller.loadPeople(widget.courseOfferingId);
    // if (Get.isRegistered<PeopleController>()) {
    //   controller = Get.find<PeopleController>();
    //   controller.clear();
    // } else {
    //   controller = Get.put(PeopleController());
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clear();
      controller.loadPeople(widget.courseOfferingId);
    });
  }

  void _search(String value) {
    // setState(() {
    controller.search(value);

    // filtered = controller.people.where((user) {
    //   final name = (user['name'] ?? '').toString().toLowerCase();
    //   final email = (user['email'] ?? '').toString().toLowerCase();

    //   return name.contains(value.toLowerCase()) ||
    //       email.contains(value.toLowerCase());
    // }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF1E1B4B),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "People",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search people...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 THIS IS THE FIX
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredPeople.isEmpty) {
                  return const Center(
                    child: Text("No people found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.filteredPeople.length,
                  itemBuilder: (context, index) {
                    final person = controller.filteredPeople[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          UserAvatar(
                            name: person['name'] ?? '',
                            photoUrl: person['photoUrl'] ?? '',
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(person['name'] ?? ''),
                                Text(
                                  person['email'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              final chatController = Get.find<ChatController>();

                              await chatController.openChat(
                                otherUserId: person['id'],
                                courseOfferingId: widget.courseOfferingId,
                              );

                              Get.toNamed(AppRoutes.chatConversation);
                            },
                            child: const Icon(Icons.chat),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
