import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/instructor_qr_controller.dart';

class InstructorQrPage extends StatelessWidget {
  final String courseOfferingId;

  const InstructorQrPage({
    super.key,
    required this.courseOfferingId,
  });


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      InstructorQrController(
        courseOfferingId: courseOfferingId,
      ),
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Get.delete<InstructorQrController>();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Attendance QR',
          ),
        ),
        body: Center(
          child: Obx(() {
            if (controller.isLoading.value && controller.qrData.value.isEmpty) {
              return const CircularProgressIndicator();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Students can scan this QR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: controller.qrData.value,
                    size: 250,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'QR refreshes every 30 seconds',
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
