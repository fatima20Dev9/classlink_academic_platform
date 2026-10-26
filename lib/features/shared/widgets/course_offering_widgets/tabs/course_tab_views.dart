import 'package:flutter/material.dart';
import 'package:get/get.dart';
// tabs
import '../../../../instructor/screens/tab_assignments.dart';
import '../../../../instructor/screens/attendance_sessions_page.dart';
import '../../../../instructor/screens/tab_grades.dart';
import '../../../../student/screens/tab_assignments_student.dart';
import '../../../../student/screens/tab_attendance.dart';
import '../../../../student/screens/tab_grades.dart';
import '../../../screens/tab_chat.dart';
import '../../../screens/tab_overview.dart';
import '../../../screens/tab_lectures.dart';
// models
import '../../../../../models/course_details_model.dart';


class CourseTabViews extends StatelessWidget {
  final String role;
  final CourseDetailsViewModel data;

  const CourseTabViews({
    super.key,
    required this.role,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    return TabBarView(
      children: [
        OverviewTab(role: role, data: data),
        role == 'student' 
          ? const GradesTab() 
          : InstructorGradesTab(),

        role == 'student'
          ? AttedencePage(
            courseOfferingId: data.offering.id,
          )
          : AttendanceSessionsPage(
            courseOfferingId: data.offering.id,
          ),
        LecturesTab(
          courseOfferingId: data.offering.id,
          role: role,
        ),
        role == 'student'
            ?  AssignmentsTabStudent(
                courseOfferingId: data.offering.id,
            )
            : AssignmentsTab(
                courseOfferingId: data.offering.id,
                role: role,
              ),
        const ChatPage(),
      ],
    );
  }
}
