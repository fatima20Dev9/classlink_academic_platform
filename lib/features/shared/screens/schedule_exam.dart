import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

// Lets an instructor schedule an exam for a course offering.
class ScheduleExamScreen extends StatefulWidget {
  const ScheduleExamScreen({super.key});

  @override
  State<ScheduleExamScreen> createState() => _ScheduleExamScreenState();
}

class _ScheduleExamScreenState extends State<ScheduleExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  String? get _courseOfferingId => Get.arguments is Map
      ? Get.arguments['courseOfferingId'] as String?
      : null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await FirebaseService.instance.firestore.collection('exams').add({
        'courseOfferingId': _courseOfferingId,
        'title': _title.text.trim(),
        'location': _location.text.trim(),
        'date': Timestamp.fromDate(_date),
        'createdAt': Timestamp.now(),
      });
      Get.back();
      Get.snackbar('Saved', 'Exam scheduled successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Exam'),
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _title,
                hint: 'Exam title',
                icon: Icons.title,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _location,
                hint: 'Location',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                    '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
                trailing:
                    TextButton(onPressed: _pickDate, child: const Text('Pick')),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Schedule Exam',
                isLoading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
