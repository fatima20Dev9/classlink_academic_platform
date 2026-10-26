import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;
  double _scale = 0.85;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;

      setState(() {
        _opacity = 1;
        _scale = 1;
      });
    });

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Get.off(
        () => const AuthGate(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 700),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E244B);
    const Color accentColor = Color(0xFF728FCE);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutBack,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ClassLink_logo.png',
                        width: 220,
                      ),


                      const SizedBox(height: 45),

                      const SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1500),
                child: Column(
                  children: [
                    Text(
                      "Connecting your learning",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Version 2.1",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}