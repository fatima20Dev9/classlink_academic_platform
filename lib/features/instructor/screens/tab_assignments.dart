import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/assignment_controller.dart';
import '../widgets/assignment_widgets/create_assignment_widget.dart';
import '../widgets/assignment_widgets/assignment_card.dart';

class AssignmentsTab extends StatefulWidget {
  final String courseOfferingId;
  final String role;

  const AssignmentsTab({
    super.key,
    required this.courseOfferingId,
    required this.role,
  });

  @override
  State<AssignmentsTab> createState() => _AssignmentsTabState();
}

class _AssignmentsTabState extends State<AssignmentsTab> {
  final controller = Get.find<AssignmentController>();

  @override
  void initState() {
    super.initState();
    controller.load(widget.courseOfferingId);
  }

  void openCreate() {
    Get.bottomSheet(
      CreateAssignmentWidget(
        courseOfferingId: widget.courseOfferingId,
        instructorId: FirebaseAuth.instance.currentUser?.uid ?? '',
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openCreate,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        print(
          "Assignments length = ${controller.assignments.length}",
        );
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.assignments.isEmpty) {
          return const Center(child: Text("No assignments"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.assignments.length,
          itemBuilder: (_, i) {
            final a = controller.assignments[i];

            return AssignmentCard(
              assignment: a,
              onDelete: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Delete Assignment'),
                    content: const Text(
                      'Are you sure?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  controller.deleteAssignment(
                    a.id,
                    widget.courseOfferingId,
                  );
                }
              },
              onEdit: () {
                Get.bottomSheet(
                  CreateAssignmentWidget(
                    courseOfferingId: widget.courseOfferingId,
                    instructorId: FirebaseAuth.instance.currentUser?.uid ?? '',
                    assignment: a, // للتعديل
                  ),
                  isScrollControlled: true,
                );
              },
            );
          },
        );
      }),
    );
  }
}
