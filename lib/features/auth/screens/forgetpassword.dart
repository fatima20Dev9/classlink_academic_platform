import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';
import '../../../core/utils/app_colors.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find<AuthController>();

  bool isUniversityEmail(String email) =>
      email.contains('@') && email.endsWith('.edu') || email.contains('@');

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text("Back to Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "No worries! Enter your email and we'll send you reset instructions.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container(color: Colors.white)),
            ],
          ),
          Positioned(
            top: h * 0.40,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: w * 0.85 > 420 ? 420 : w * 0.85,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Email Address",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: emailController,
                            hint: 'student@university.edu',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              if (!value.contains("@")) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Obx(() => CustomButton(
                                text: 'Send Reset Link',
                                icon: Icons.arrow_forward_sharp,
                                isLoading: _auth.isLoading,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _auth.sendReset(
                                      emailController.text.trim(),
                                    );
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
