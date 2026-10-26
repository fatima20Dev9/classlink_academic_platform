import 'package:flutter/material.dart';

class SubmissionTabs extends StatelessWidget {
  final int activeIndex;
  final Function(int) onChange;

  const SubmissionTabs({
    super.key,
    required this.activeIndex,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTab(
            context: context,
            title: "Instructions",
            index: 0,
          ),
          _buildTab(
            context: context,
            title: "Student Work",
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String title,
    required int index,
  }) {
    final isActive = activeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}