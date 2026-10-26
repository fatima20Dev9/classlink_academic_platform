import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';
import '../../../core/utils/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  // final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'student';

  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Join ClassLink',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              // CustomTextField(
              //   controller: nameController,
              //   hint: 'Full Name',
              //   icon: Icons.person,
              //   validator: (v) =>
              //       v == null || v.isEmpty ? 'Enter your name' : null,
              // ),
              // const SizedBox(height: 14),
              CustomTextField(
                controller: emailController,
                hint: 'University Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: passwordController,
                hint: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (v) => v == null || v.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'student',
                          groupValue: role,
                          title: const Text('Student'),
                          onChanged: (v) => setState(() => role = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'instructor',
                          groupValue: role,
                          title: const Text('Instructor'),
                          onChanged: (v) => setState(() => role = v!),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Obx(() => CustomButton(
                    text: 'Create Account',
                    isLoading: _auth.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          // name: nameController.text.trim(),
                          role: role,
                        );
                      }
                    },
                  )),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Already have an account? Login',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
