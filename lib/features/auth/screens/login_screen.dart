import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool firstSwitch = true; // true = Student | false = Instructor

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 24),
                  // child: Image.asset(
                  //   "images/hat.png",
                  //   width: 50,
                  //   errorBuilder: (_, __, ___) =>
                  //       const Icon(Icons.school, color: Colors.white, size: 40),
                  // ),
                  child: Icon(Icons.school, color: Theme.of(context).colorScheme.onPrimary, size: 40),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Log in to access your university portal.",
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)),
                       
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.12), blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: [
                          AnimatedToggleSwitch<bool>.size(
                            current: firstSwitch,
                            values: const [true, false],
                            indicatorSize: const Size.fromWidth(200),
                            customIconBuilder: (context, local, global) => Text(
                              local.value ? "Student" : "Instructor",
                              style: TextStyle(
                                color: Color.lerp(
                                  Theme.of(context).colorScheme.onBackground,
                                  Theme.of(context).colorScheme.onPrimary,
                                  local.animationValue,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ToggleStyle(
                              indicatorColor: AppColors.primary,
                              borderColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onChanged: (value) {
                              setState(() => firstSwitch = value);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration(
                              "University Email",
                              Icons.email,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter email"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: _inputDecoration(
                              "Password",
                              Icons.lock,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter password"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.forgotPassword),
                              child: Text(
                                "Forget Password?",
                                style:
                                    TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                              ),
                            ),
                          ),
                          Obx(() => CustomButton(
                                text: 'Login',
                                isLoading: _auth.isLoading,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _auth.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
