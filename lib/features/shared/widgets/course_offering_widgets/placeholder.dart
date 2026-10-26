import 'package:flutter/material.dart';

class PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String text;

  const PlaceholderTab({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}