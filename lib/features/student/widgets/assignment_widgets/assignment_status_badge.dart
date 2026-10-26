import 'package:flutter/material.dart';

class AssignmentStatusBadge extends StatelessWidget {
  final String status;

  const AssignmentStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;

      case 'closed':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;

      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
