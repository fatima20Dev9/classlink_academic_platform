import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/assignment_controller.dart';
import '../../../../models/assignment_model.dart';

class CreateAssignmentWidget extends StatefulWidget {
  final String courseOfferingId;
  final String instructorId;
  final AssignmentModel? assignment;

  const CreateAssignmentWidget({
    super.key,
    required this.courseOfferingId,
    required this.instructorId,
    this.assignment,
  });

  @override
  State<CreateAssignmentWidget> createState() => _CreateAssignmentWidgetState();
}

class _CreateAssignmentWidgetState extends State<CreateAssignmentWidget> {
  final AssignmentController controller = Get.find<AssignmentController>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final maxGradeController = TextEditingController(text: "10");

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
  @override
  void initState() {
    super.initState();

    if (widget.assignment != null) {
      titleController.text = widget.assignment!.title;
      descController.text = widget.assignment!.description;
      maxGradeController.text = widget.assignment!.maxGrade.toString();

      selectedDate = widget.assignment!.dueDate.toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            widget.assignment == null ? "Create Assignment" : "Edit Assignment",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title *",
              // prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Description (Optional)",
              // prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: maxGradeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Max Grade *",
              // prefixIcon: const Icon(Icons.grade),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (date != null) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Due Date *",
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              await controller.pickFile();
              setState(() {});
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Attachment (Optional)",
                prefixIcon: const Icon(Icons.attach_file),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                controller.fileName.isEmpty
                    ? "No file selected"
                    : controller.fileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.assignment == null) {
                          await controller.createAssignment(
                            courseOfferingId: widget.courseOfferingId,
                            instructorId: widget.instructorId,
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            dueDate: selectedDate,
                            maxGrade:
                                double.tryParse(maxGradeController.text) ?? 100,
                          );
                        } else {
                          await controller.updateAssignment(
                            courseOfferingId: widget.courseOfferingId,
                            assignmentId: widget.assignment!.id,
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            dueDate: selectedDate,
                            maxGrade:
                                double.tryParse(maxGradeController.text) ?? 10,
                          );
                        }

                        if (controller.error.value.isEmpty) {
                          Get.back();

                          Get.snackbar(
                            "Success",
                            widget.assignment == null
                                ? "Assignment created successfully"
                                : "Assignment updated successfully",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1B4B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.assignment == null
                            ? "Create Assignment"
                            : "Update Assignment",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
