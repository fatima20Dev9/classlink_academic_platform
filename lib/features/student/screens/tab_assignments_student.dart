import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../student/controllers/assignment_controller.dart';
import '../widgets/assignment_widgets/assignment_card.dart';
import '../widgets/assignment_widgets/assignment_filter_tabs.dart';

class AssignmentsTabStudent extends StatefulWidget {
  final String courseOfferingId;

  const AssignmentsTabStudent({
    super.key,
    required this.courseOfferingId,
  });

  @override
  State<AssignmentsTabStudent> createState() =>
      _AssignmentsTabStudentState();
}

class _AssignmentsTabStudentState
    extends State<AssignmentsTabStudent> {

  late final StudentAssignmentController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      StudentAssignmentController(
        courseOfferingId: widget.courseOfferingId,
      ),
      tag: widget.courseOfferingId,
    );
  }

  @override
  void dispose() {
    Get.delete<StudentAssignmentController>(
      tag: widget.courseOfferingId,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// FILTERS
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AssignmentFilterTabs(
                  selectedFilter: controller.filter.value,
                  onChanged: controller.changeFilter,
                ),
              )),

          /// CONTENT
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.loadAssignments,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.filteredAssignments.isEmpty) {
                return const Center(
                  child: Text('No assignments found'),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadAssignments,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: controller.filteredAssignments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    final item = controller.filteredAssignments[index];
                    return AssignmentCard(item: item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
