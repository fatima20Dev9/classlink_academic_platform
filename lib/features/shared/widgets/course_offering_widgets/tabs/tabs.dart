import 'package:flutter/material.dart';

class CourseTabs {
  static const TabBar bar = TabBar(
    isScrollable: true,
    labelColor: Color(0xFF1E1B4B),
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xFF1E1B4B),
    tabs: [
      Tab(text: 'Overview'),
      Tab(text: 'Grades'),
      Tab(text: 'Attendance'),
      Tab(text: 'Lectures'),
      Tab(text: 'Assignments'),
      Tab(text: 'Chat'),
    ],
  );
}