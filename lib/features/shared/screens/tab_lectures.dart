import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lectures_controller.dart';
// import '../../../models/lecture_model.dart';
import '/features/shared/widgets/add_lecture_widgets/add_lecture_widget.dart';

class LecturesTab extends StatefulWidget {
  final String courseOfferingId;
  final String role;

  const LecturesTab({
    super.key,
    required this.courseOfferingId,
    required this.role,
  });

  @override
  State<LecturesTab> createState() => _LecturesTabState();
}

class _LecturesTabState extends State<LecturesTab> {
  final LecturesController controller = Get.find();

  String? downloadingFile;

  @override
  void initState() {
    super.initState();
    controller.loadLectures(widget.courseOfferingId);
  }

  void openAddLecture() {
    Get.bottomSheet(
      AddLectureWidget(
        courseOfferingId: widget.courseOfferingId,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.role == "instructor"
          ? FloatingActionButton(
              onPressed: openAddLecture,
              child: const Icon(Icons.add),
            )
          : null,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.lectures.isEmpty) {
          return const Center(child: Text("No lectures"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.lectures.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final lecture = controller.lectures[index];

            return ListTile(
              title: Text(lecture.file.name),
              subtitle: Text("${lecture.file.size} MB"),
              trailing: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {},
              ),
            );
          },
        );
      }),
    );
  }
}