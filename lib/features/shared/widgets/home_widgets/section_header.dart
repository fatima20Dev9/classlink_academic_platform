import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (actionText != null)
          TextButton(
            onPressed: onPressed ??
                () {
                  debugPrint('No action defined for $title');
                },
            child: Text(actionText!),
          ),
      ],
    );
  }
}
 