import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../repositories/attendance_repository.dart';
import '../../../features/auth/controllers/session_controller.dart';
import '../../../core/services/attendance_session_service.dart';

class StudentQrScannerPage extends StatefulWidget {
  final String courseOfferingId;

  const StudentQrScannerPage({
    super.key,
    required this.courseOfferingId,
  });

  @override
  State<StudentQrScannerPage> createState() => _StudentQrScannerPageState();
}

class _StudentQrScannerPageState extends State<StudentQrScannerPage> {
  bool isProcessing = false;
  String? lastScannedCode;

  final MobileScannerController cameraController = MobileScannerController();

  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();

  final AttendanceSessionService _sessionService =
      Get.find<AttendanceSessionService>();

  final SessionController _session = Get.find<SessionController>();

Future<void> _handleScan(String code) async {
  print("QR DATA = $code");
  if (isProcessing) return;

  if (lastScannedCode == code) return;

  setState(() {
    isProcessing = true;
    lastScannedCode = code;
  });

  try {

    print('SCANNED QR = $code');

    final parts = code.split('|');

    if (parts.length != 3) {
      _showMessage(
        'Invalid QR format',
        Colors.red,
      );
      return;
    }

    final qrCourseOfferingId = parts[0];
    final sessionId = parts[1];
    final sessionKey = parts[2];

    if (qrCourseOfferingId != widget.courseOfferingId) {
      _showMessage(
        'This QR belongs to another course',
        Colors.red,
      );
      return;
    }
final studentId = _session.uid;

if (studentId == null) {
  _showMessage(
    'Student not found',
    Colors.red,
  );
  return;
}
      final success = await _attendanceRepo.markAttendanceIfNotExists(
        studentId: studentId,
        courseOfferingId: widget.courseOfferingId,
        sessionId: sessionId,
      );

      if (!success) {
        _showMessage('Already marked present', Colors.orange);
        return;
      }

      _showMessage('Attendance marked successfully', Colors.green);

      cameraController.stop();

      await Future.delayed(const Duration(seconds: 1));

      Get.back();
    } catch (e) {
      _showMessage('Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() => isProcessing = false);
    }
  }

  void _showMessage(String msg, Color color) {
    Get.snackbar(
      'Attendance',
      msg,
      backgroundColor: color.withOpacity(0.1),
      colorText: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Attendance QR'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;

              if (barcodes.isEmpty) return;

              final code = barcodes.first.rawValue;

              if (code == null) return;

              _handleScan(code);
            },
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
