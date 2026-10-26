import 'package:flutter/material.dart';

// Temporary model class for testing
class Lecture {
  final String id;
  final String courseId;
  final String courseName;
  final String instructor;
  final String day;
  final String startTime;
  final String endTime;
  final String location;
  final Color color;

  Lecture({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.instructor,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.color,
  });
}

class LectureSchedulePage extends StatefulWidget {
  const LectureSchedulePage({super.key});

  @override
  State<LectureSchedulePage> createState() => _LectureSchedulePageState();
}

class _LectureSchedulePageState extends State<LectureSchedulePage> {
  String? selectedDay;

  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
  ];
  
  // Temporary lectures data for testing
  final List<Lecture> lectures = [
    Lecture(
      id: 'lec1',
      courseId: 'cs101',
      courseName: 'Intro to Computer Science',
      instructor: 'Dr. Sarah Johnson',
      day: 'Sunday',
      startTime: '09:00',
      endTime: '10:30',
      location: 'Building A, Room 101',
      color: Colors.blue,
    ),
    Lecture(
      id: 'lec2',
      courseId: 'math101',
      courseName: 'Calculus I',
      instructor: 'Prof. James Wilson',
      day: 'Sunday',
      startTime: '11:00',
      endTime: '12:30',
      location: 'Building B, Room 205',
      color: Colors.purple,
    ),
    Lecture(
      id: 'lec3',
      courseId: 'phys101',
      courseName: 'Physics I: Mechanics',
      instructor: 'Dr. Lisa Anderson',
      day: 'Sunday',
      startTime: '14:00',
      endTime: '15:30',
      location: 'Building C, Lab 301',
      color: Colors.blue,
    ),
    Lecture(
      id: 'lec4',
      courseId: 'cs201',
      courseName: 'Data Structures & Algorithms',
      instructor: 'Prof. Michael Chen',
      day: 'Monday',
      startTime: '09:00',
      endTime: '10:30',
      location: 'Building A, Room 102',
      color: Colors.green,
    ),
    Lecture(
      id: 'lec5',
      courseId: 'eng101',
      courseName: 'English Composition',
      instructor: 'Prof. David Martinez',
      day: 'Monday',
      startTime: '13:00',
      endTime: '14:30',
      location: 'Building B, Room 301',
      color: Colors.green,
    ),
    Lecture(
      id: 'lec6',
      courseId: 'cs301',
      courseName: 'Web Development',
      instructor: 'Dr. Emily Rodriguez',
      day: 'Tuesday',
      startTime: '10:00',
      endTime: '11:30',
      location: 'Building D, Computer Lab',
      color: Colors.orange,
    ),
    Lecture(
      id: 'lec7',
      courseId: 'cs201',
      courseName: 'Data Structures & Algorithms',
      instructor: 'Prof. Michael Chen',
      day: 'Tuesday',
      startTime: '14:00',
      endTime: '15:30',
      location: 'Building A, Room 102',
      color: Colors.green,
    ),
    Lecture(
      id: 'lec8',
      courseId: 'math101',
      courseName: 'Calculus I',
      instructor: 'Prof. James Wilson',
      day: 'Wednesday',
      startTime: '11:00',
      endTime: '12:30',
      location: 'Building B, Room 205',
      color: Colors.purple,
    ),
    Lecture(
      id: 'lec9',
      courseId: 'cs101',
      courseName: 'Intro to Computer Science',
      instructor: 'Dr. Sarah Johnson',
      day: 'Wednesday',
      startTime: '15:00',
      endTime: '16:30',
      location: 'Building A, Room 101',
      color: Colors.blue,
    ),
    Lecture(
      id: 'lec10',
      courseId: 'phys101',
      courseName: 'Physics I: Mechanics',
      instructor: 'Dr. Lisa Anderson',
      day: 'Thursday',
      startTime: '10:00',
      endTime: '11:30',
      location: 'Building C, Lab 301',
      color: Colors.blue,
    ),
    Lecture(
      id: 'lec11',
      courseId: 'cs301',
      courseName: 'Web Development',
      instructor: 'Dr. Emily Rodriguez',
      day: 'Thursday',
      startTime: '13:00',
      endTime: '14:30',
      location: 'Building D, Computer Lab',
      color: Colors.orange,
    ),
  ];

  List<Lecture> getLecturesForDay(String day) {
    return lectures.where((lecture) => lecture.day == day).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isTablet =
        MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Lectures',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your schedule for Fall 2025',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          if (isMobile)
            _buildMobileView()
          else if (isTablet)
            _buildTabletView()
          else
            _buildDesktopView(),
        ],
      ),
    );
  }

  Widget _buildDesktopView() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Schedule Grid
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                    verticalInside: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[50]),
                      children: [
                        _buildHeaderCell('Time'),
                        _buildHeaderCell('Sunday'),
                        _buildHeaderCell('Monday'),
                        _buildHeaderCell('Tuesday'),
                        _buildHeaderCell('Wednesday'),
                        _buildHeaderCell('Thursday'),
                      ],
                    ),
                    // Time Slots
                    ...generateTimeSlots().map((timeSlot) {
                      return TableRow(
                        children: [
                          _buildTimeCell(timeSlot),
                          ...days.map((day) {
                            final lecture =
                                lectures
                                    .where(
                                      (l) =>
                                          l.day == day &&
                                          l.startTime == timeSlot,
                                    )
                                    .isNotEmpty
                                ? lectures.firstWhere(
                                    (l) =>
                                        l.day == day && l.startTime == timeSlot,
                                  )
                                : null;

                            return _buildGridCell(lecture);
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Legend
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletView() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days
                    .map(
                      (day) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = selectedDay == day ? null : day;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == day
                                  ? Colors.blue
                                  : Colors.white,
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              day.substring(0, 3),
                              style: TextStyle(
                                color: selectedDay == day
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Lectures List
            _buildLecturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileView() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days
                    .map(
                      (day) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = selectedDay == day ? null : day;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == day
                                  ? Color(0xFF1E1B4B)
                                  : Colors.white,
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              day.substring(0, 3),
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedDay == day
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Lectures List
            _buildLecturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturesList() {
    if (selectedDay != null) {
      // Show only selected day
      final dayLectures = getLecturesForDay(selectedDay!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedDay!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (dayLectures.isNotEmpty)
            ...dayLectures.map((lecture) => _buildLectureCard(lecture)).toList()
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No lectures on $selectedDay',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
        ],
      );
    } else {
      // Show all days
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: days.map((day) {
          final dayLectures = getLecturesForDay(day);
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (dayLectures.isNotEmpty)
                  ...dayLectures
                      .map((lecture) => _buildLectureCard(lecture))
                      .toList()
                else
                  Text(
                    'No lectures scheduled',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildLectureCard(Lecture lecture) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lecture.color.withOpacity(0.08),
        border: Border.all(color: lecture.color.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lecture.courseName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lecture.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lecture.startTime,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: lecture.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${lecture.startTime} - ${lecture.endTime}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lecture.instructor,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lecture.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[50],
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTimeCell(String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[50],
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildGridCell(Lecture? lecture) {
    if (lecture == null) {
      return Container(padding: const EdgeInsets.all(8), height: 120);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      height: 120,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: lecture.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: lecture.color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lecture.courseName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: lecture.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${lecture.startTime} - ${lecture.endTime}',
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Colors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3.5,
            children: [
              _buildLegendItem(Colors.blue, 'CS & Physics'),
              _buildLegendItem(Colors.green, 'Data Structures\n& English'),
              _buildLegendItem(Colors.orange, 'Web\nDevelopment'),
              _buildLegendItem(Colors.purple, 'Mathematics'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<String> generateTimeSlots() {
    final slots = <String>[];
    for (int hour = 9; hour < 17; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}:00');
    }
    return slots;
  }
}
