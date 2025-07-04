import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final String name;
  final double radius;
  final VoidCallback? onTap;
  final bool clickable;

  const ProfileAvatarWidget({
    super.key,
    required this.name,
    this.onTap,
    this.radius = 20,
    this.clickable = true,
  });

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImageUrl();
  }

  Future<void> _loadProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('userPhoto');
    if (url != null && url.isNotEmpty) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.name.trim().isNotEmpty
        ? widget.name.trim()[0].toUpperCase()
        : '?';

    final avatar = imageUrl != null
        ? CircleAvatar(
            radius: widget.radius,
            backgroundImage: NetworkImage(imageUrl!),
            onBackgroundImageError: (_, __) {
              setState(() {
                imageUrl = null;
              });
            },
          )
        : CircleAvatar(
            radius: widget.radius,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: widget.radius * 0.9,
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );

    return widget.clickable
        ? GestureDetector(onTap: widget.onTap, child: avatar)
        : avatar;
  }
}
