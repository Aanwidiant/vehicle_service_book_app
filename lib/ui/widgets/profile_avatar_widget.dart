import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;

  const ProfileAvatarWidget({super.key, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          initial,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
