import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/course_details_model.dart';
import '../../screens/add_course.dart';
import '../../screens/course_offering.dart';
import '../../controllers/course_offering_controller.dart';

class HomeCourseCard extends StatelessWidget {
  final CourseDetailsViewModel course;
  final bool isInstructor;

  const HomeCourseCard({
    super.key,
    required this.course,
    required this.isInstructor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseOfferingController>();

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseOfferingPage(
              data: course,
            ),
          ),
        );
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: course.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course.instructorName,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            if (isInstructor)
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'code':
                        _showInviteCode(context);
                        break;

                      case 'edit':
                        Get.to(
                          () => const AddCoursePage(),
                          arguments: {
                            'course': course.course,
                            'offering': course.offering,
                          },
                        );
                        break;

                      case 'delete':
                        _confirmDelete(context, controller);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'code',
                      child: Text('Invite Code'),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Course'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Course'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    CourseOfferingController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Course'),
        content: const Text(
          'Are you sure you want to delete this course? This action cannot be undone and will remove all enrollments.',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Get.back(); // close dialog

              await controller.deleteOffering(course.offering.id);

              // Get.snackbar(
              //   'Success',
              //   'Course deleted successfully',
              //   backgroundColor: Colors.green,
              //   colorText: Colors.white,
              // );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showInviteCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Invite Code'),
        content: SelectableText(
          course.offering.inviteCode,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
