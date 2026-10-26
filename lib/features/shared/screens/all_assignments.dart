import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_assignments_controller.dart';

// Instructor Card
import '../../instructor/widgets/assignment_widgets/assignment_card.dart'
    as instructor;

// Student Card
import '../../student/widgets/assignment_widgets/assignment_card.dart'
    as student;

class AllAssignmentsPage extends GetView<AllAssignmentsController> {
  final bool isStudent;

  const AllAssignmentsPage({
    super.key,
    required this.isStudent,
  });

  @override
  Widget build(BuildContext context) {
    /// 🔥 Trigger correct load based on role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isStudent) {
        controller.loadStudentAssignments();
      } else {
        controller.loadInstructorAssignments();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'All Assignments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search assignment...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          /// 📄 LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// =========================
              /// STUDENT VIEW
              /// =========================
              if (isStudent) {
                final items =
                    controller.filteredStudentAssignments;

                if (items.isEmpty) {
                  return const Center(
                    child: Text('No assignments found'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final item = items[index];

                    return student.AssignmentCard(
                      item: item,
                    );
                  },
                );
              }

              /// =========================
              /// INSTRUCTOR VIEW
              /// =========================
              final items =
                  controller.filteredInstructorAssignments;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No assignments found'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final item = items[index];

                  return instructor.AssignmentCard(
                    assignment: item,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}