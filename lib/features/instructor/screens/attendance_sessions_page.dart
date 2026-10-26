import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/attendance_sessions_controller.dart';
import '../../../models/attendance_session_model.dart';

class AttendanceSessionsPage extends StatefulWidget {
  final String courseOfferingId;

  const AttendanceSessionsPage({
    super.key,
    required this.courseOfferingId,
  });

  @override
  State<AttendanceSessionsPage> createState() => _AttendanceSessionsPageState();
}

class _AttendanceSessionsPageState extends State<AttendanceSessionsPage> {
  late final AttendanceSessionsController controller;

  @override
  void initState() {
    super.initState();

    // controller = Get.put(
    //   AttendanceSessionsController(),
    // );
    controller = Get.isRegistered<AttendanceSessionsController>()
        ? Get.find<AttendanceSessionsController>()
        : Get.put(
            AttendanceSessionsController(),
          );

    controller.loadSessions(
      widget.courseOfferingId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.sessions.isEmpty) {
          return const Center(
            child: Text(
              'No attendance sessions yet',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.sessions.length,
          itemBuilder: (
            context,
            index,
          ) {
            final session = controller.sessions[index];

            return _SessionCard(
              session: session,
              controller: controller,
            );
          },
        );
      }),
    );
  }
}

class _SessionCard extends StatefulWidget {
  final AttendanceSessionModel session;
  final AttendanceSessionsController controller;

  const _SessionCard({
    required this.session,
    required this.controller,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final date = widget.session.createdAt.toDate();

    return Obx(() {
      final records = widget.controller.sessionRecords[widget.session.id] ?? [];

      return Container(
        margin: const EdgeInsets.only(
          bottom: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(
            color: Colors.green.shade300,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onExpansionChanged: (
            value,
          ) async {
            setState(() {
              expanded = value;
            });

            if (value) {
              await widget.controller.loadSessionRecords(
                widget.session.id,
              );
            }
          },
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              widget.session.lectureNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            'Lecture ${widget.session.lectureNumber}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${date.day}/${date.month}/${date.year}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  records.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
            ],
          ),
          children: [
            if (records.isEmpty && expanded)
              const Padding(
                padding: EdgeInsets.all(
                  16,
                ),
                child: Text(
                  'No attendance records',
                ),
              ),
            ...records.map(
              (record) => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    record.studentName ?? record.studentId,
                  ),
                  subtitle: Text(
                    '${record.attendedAt.toDate().hour}:${record.attendedAt.toDate().minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
