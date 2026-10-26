import 'package:flutter/material.dart';
import '../../../models/course_details_model.dart';

// Shared overview tab for both student & instructor views of a course offering
// Falls back to the CourseModel info when no offering is set
class OverviewTab extends StatelessWidget {
  final CourseDetailsViewModel data;
  final String role;

  const OverviewTab({
    super.key,
    required this.data,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final description = data.overview.isNotEmpty
        ? data.overview
        : 'No description available';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: 'Description',
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  context: context,
                  icon: Icons.menu_book,
                  label: 'Credits',
                  value: '${data.credits}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  context: context,
                  icon: Icons.calendar_today,
                  label: 'Semester',
                  value: data.semester.isEmpty ? '—' : data.semester,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: 'Instructor',
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: data.color,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      data.instructorName.isEmpty
                          ? 'Unknown Instructor'
                          : data.instructorName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildStatTile(
      {required BuildContext context,required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
