import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';
import '../../../core/utils/app_colors.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String role;

  const CompleteProfileScreen({
    super.key,
    required this.role,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final specializationController = TextEditingController();
  final levelController = TextEditingController();

  final AuthController _auth = Get.find<AuthController>();

  bool get isStudent => widget.role == 'student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile', style: TextStyle(color: AppColors.background),),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                'Complete Your Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isStudent
                    ? 'Please enter your student information'
                    : 'Please enter your instructor information',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              // Name
              CustomTextField(
                controller: nameController,
                hint: 'Full Name',
                icon: Icons.person,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your full name' : null,
              ),

              const SizedBox(height: 14),

              // Phone
              CustomTextField(
                controller: phoneController,
                hint: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your phone number' : null,
              ),

              const SizedBox(height: 14),

              // Specialization
              CustomTextField(
                controller: specializationController,
                hint: 'Specialization',
                icon: Icons.school,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter specialization' : null,
              ),

              // Student Level
              if (isStudent) ...[
                const SizedBox(height: 14),
                CustomTextField(
                  controller: levelController,
                  hint: 'Level',
                  icon: Icons.bar_chart,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your level' : null,
                ),
              ],

              const SizedBox(height: 28),

              // Submit Button
              Obx(
                () => CustomButton(
                  text: 'Save Information',
                  isLoading: _auth.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _auth.completeProfile(
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        specialization: specializationController.text.trim(),
                        level: isStudent ? levelController.text.trim() : null,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
