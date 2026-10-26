import 'package:classlink_academic_platform/models/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/attendance_controller.dart';

class AttedencePage extends StatefulWidget {
  final String courseOfferingId;

  const AttedencePage({
    super.key,
    required this.courseOfferingId,
    });

  @override
  State<AttedencePage> createState() => _AttedencePageState();
}

class _AttedencePageState extends State<AttedencePage> {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  void initState() {
    super.initState();

    controller.loadStudentRecords(
      widget.courseOfferingId,
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final records = controller.records;
      final totalClasses = records.length;
      final presentCount =
          records.where((e) => e.status == AttendanceStatus.present).length;
      final absentCount = totalClasses - presentCount;
      final progress = totalClasses == 0 ? 0.0 : presentCount / totalClasses;

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Attendance Rate
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          213,
                          210,
                          211,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Attendance Rate",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ClipRect(
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              value: progress,
                              minHeight: 7,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "$presentCount out of $totalClasses classes",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Present & Absent
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.green.shade100,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Present",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "$presentCount",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${(progress * 100).toStringAsFixed(0)}% of total",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.red.shade100,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "Absent",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "$absentCount",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  totalClasses == 0
                                      ? "0%"
                                      : "${((absentCount / totalClasses) * 100).toStringAsFixed(0)}%",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Attendance Records",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];

                      return _attendanceCard(
                        isPresent: record.status == AttendanceStatus.present,
                        date: formatDate(
                          record.date.toDate(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          174,
                          209,
                          237,
                        ),
                      ),
                      color: const Color.fromARGB(
                        255,
                        222,
                        239,
                        253,
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: const Text(
                      "Note: Regular attendance is important for your academic success.",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _attendanceCard({
    required bool isPresent,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isPresent ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isPresent
              ? const Color.fromARGB(
                  255,
                  112,
                  199,
                  115,
                )
              : const Color.fromARGB(
                  255,
                  225,
                  147,
                  141,
                ),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            isPresent
                ? Icons.check_circle_outline_outlined
                : Icons.cancel_outlined,
            color: isPresent
                ? const Color.fromARGB(
                    255,
                    101,
                    186,
                    104,
                  )
                : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPresent ? "Attendance Recorded" : "Absent",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isPresent ? "Present" : "Absent",
            style: TextStyle(
              color: isPresent ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
