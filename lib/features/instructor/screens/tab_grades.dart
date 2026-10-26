import 'package:flutter/material.dart';

// Grades Tab .........................................
class InstructorGradesTab extends StatelessWidget {
     InstructorGradesTab({super.key});
  final List<Map<String, String>> students = List.generate(
    70,
    (index) => {
      'name': 'Student ${index + 1}',
      'attendance': '${8 + (index % 3)}/10',
      'assignments': '${20 + (index % 10)}/30',
      'midterm': '${14 + (index % 6)}/20',
      'total': '${80 + (index % 15)}%',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // const Text(
            //   "Class Grades Overview",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF1E1B4B),
            //   ),
            // ),
            // const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color.fromARGB(162, 30, 27, 75)),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue.withOpacity(0.2);
                    }
                    return Colors.grey[50]; // alternating row background
                  },
                ),
                columns: const [
                  DataColumn(label: Text("Student")),
                  DataColumn(label: Text("Attendance")),
                  DataColumn(label: Text("Assignments")),
                  DataColumn(label: Text("Midterm")),
                  DataColumn(label: Text("Total")),
                ],
                rows: students.map((student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student['name']!)),
                      DataCell(Text(student['attendance']!)),
                      DataCell(Text(student['assignments']!)),
                      DataCell(Text(student['midterm']!)),
                      DataCell(Text(student['total']!,
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}