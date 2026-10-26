import 'package:classlink_academic_platform/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_offering_controller.dart';
import '../../../features/auth/controllers/session_controller.dart';

class JoinCourseByCodePage extends StatefulWidget {
  const JoinCourseByCodePage({super.key});

  @override
  State<JoinCourseByCodePage> createState() => _JoinCourseByCodePageState();
}

class _JoinCourseByCodePageState extends State<JoinCourseByCodePage> {
  final TextEditingController codeController = TextEditingController();

  final CourseOfferingController controller = Get.find();
  final SessionController session = Get.find();

  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.surface,
            ),
            onPressed: () => Get.back(),
            ),
        title: const Text("Join Course", style: TextStyle(color: AppColors.surface),),
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Invite Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: "e.g. ABC123",
                      prefixIcon: const Icon(Icons.key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // JOIN BUTTON
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1B4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          final code = codeController.text.trim();

                          if (code.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please enter invite code",
                              backgroundColor: const Color.fromARGB(75, 244, 67, 54),
                              colorText: Colors.white,
                            );
                            return;
                          }

                          isLoading.value = true;

                          final result =
                              await controller.joinByInviteCode(code);

                          isLoading.value = false;

                          if (result == null) {
                            Get.snackbar(
                              "Invalid Code",
                              "No course found with this code",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              "Success",
                              "You joined the course successfully",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );

                            Get.back();
                          }
                        },
                  child: isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Join Course",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
