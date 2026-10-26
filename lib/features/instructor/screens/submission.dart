import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/submission_controller.dart';
import '../widgets/submissions_widgets/submission_header.dart';
import '../widgets/submissions_widgets/submission_tabs.dart';
import '../widgets/submissions_widgets/instructions_view.dart';
import '../widgets/submissions_widgets/student_work_view.dart';

class SubmissionPage extends StatefulWidget {
  final Map<String, dynamic> assignment;

  const SubmissionPage({
    super.key,
    required this.assignment,
  });

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  int activeTabIndex = 0;
  bool acceptingSubmissions = true;

  // final controller = Get.put(SubmissionController(
  //   userRepo: Get.find(),
  //   repository: SubmissionRepository(FirebaseFirestore.instance),
  //   service: SubmissionService(),
  // ));
  final controller = Get.find<SubmissionController>();

  @override
  void initState() {
    super.initState();

    final assignmentId = widget.assignment['id'];
    controller.listenToAssignment(assignmentId);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.assignment['title'] ?? '';
    final maxGrade = (widget.assignment['maxGrade'] ?? 0).toInt();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        return Column(
          children: [
            /// HEADER
            SubmissionHeader(
              title: title,
              maxGrade: maxGrade,
            ),

            /// TABS
            SubmissionTabs(
              activeIndex: activeTabIndex,
              onChange: (index) {
                setState(() {
                  activeTabIndex = index;
                });
              },
            ),

            /// CONTENT
            Expanded(
              child: activeTabIndex == 0
                  ? InstructionsView(
                      title: title,
                      maxGrade: maxGrade,
                      acceptingSubmissions: acceptingSubmissions,
                      onToggleAccepting: (value) {
                        setState(() {
                          acceptingSubmissions = value;
                        });
                      },

                      /// 🔥 REAL DATA FROM CONTROLLER
                      total: controller.total.value,
                      handedIn: controller.handedIn.value,
                      marked: controller.marked.value,
                    )
                  : StudentWorkView(
                      submissions: controller.submissions,
                      maxGrade: maxGrade,
                      onMark: (id, grade) async {
                        await controller.markSubmission(
                          id: id,
                          grade: grade,
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
