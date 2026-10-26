import 'package:flutter/material.dart';
// import '/models/submission_model.dart';

class InstructionsView extends StatelessWidget {
  final String title;
  final int maxGrade;

  final bool acceptingSubmissions;
  final Function(bool) onToggleAccepting;

  final int total;
  final int handedIn;
  final int marked;

  const InstructionsView({
    super.key,
    required this.title,
    required this.maxGrade,
    required this.acceptingSubmissions,
    required this.onToggleAccepting,
    required this.total,
    required this.handedIn,
    required this.marked,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          

          const SizedBox(height: 12),

          /// ================= DASHBOARD SECTION =================
Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: [
      /// 📊 STATS CARD
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat("Total", total),
            _stat("Handed In", handedIn),
            _stat("Marked", marked),
            _stat("Pending", total - handedIn),
          ],
        ),
      ),

      const SizedBox(height: 12),

      /// 📂 EXPANDABLE CARDS SECTION
      

      const SizedBox(height: 10),

      _buildExpandableCard(
        title: "Handed In",
        count: handedIn,
        color: Colors.green,
      ),

      const SizedBox(height: 10),

      _buildExpandableCard(
        title: "Marked",
        count: marked,
        color: Colors.purple,
      ),

      const SizedBox(height: 10),

      _buildExpandableCard(
        title: "Pending",
        count: total - handedIn,
        color: Colors.orange,
      ),

      const SizedBox(height: 10),

    ],
  ),
),
        ],
      ),
    );
  }

  /// ================= STAT WIDGET =================
  Widget _stat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1B4B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  Widget _buildExpandableCard({
  required String title,
  required int count,
  required Color color,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Text(
          count.toString(),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () {
        // لاحقاً: فتح قائمة الطلاب حسب الحالة
      },
    ),
  );
}
}