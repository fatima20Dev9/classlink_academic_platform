import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
          ? NetworkImage(photoUrl!)
          : null,
      child: (photoUrl == null || photoUrl!.isEmpty)
          ? Text(
              name.isNotEmpty
                  ? name[0].toUpperCase()
                  : "U",
            )
          : null,
    );
  }
}