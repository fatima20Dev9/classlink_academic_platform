import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/course_details_model.dart';
import 'course_badge.dart';
import '../../screens/people.dart';
import '../../../instructor/screens/instructor_qr_page.dart';
import '../../../../features/student/screens/student_qr_scanner_page.dart';

class CourseHeader extends StatelessWidget {
  final String role;
  final CourseDetailsViewModel data;

  const CourseHeader({
    super.key,
    required this.role,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final String name = data.courseName;
    final String instructor = data.instructorName;
    final Color color = data.color;
    final int credits = data.credits;
    final String semester = data.semester;
    final int progress = data.progress;

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.white24),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => PeoplePage(courseOfferingId: data.offeringId));
                    },
                    icon: const Icon(
                      Icons.people_outlined,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      // backgroundColor: Colors.white24,
                      overlayColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (role == 'student') ...[
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentQrScannerPage(
                              courseOfferingId: data.offering.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white24,
                        overlayColor: Colors.white,
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InstructorQrPage(
                              courseOfferingId: data.offering.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white24,
                        overlayColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Course Name
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Instructor
          Text(
            instructor,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Badges
          Row(
            children: [
              CourseBadge(text: '$credits Credits'),
              const SizedBox(width: 12),
              CourseBadge(text: semester)
            ],
          ),

          const SizedBox(height: 24),

          // Progress Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Course Progress',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '$progress%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.black12,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
