import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_book_app/constants/storage_constant.dart';
import 'package:vehicle_service_book_app/providers/user_provider.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;
  final bool clickable;

  const ProfileAvatarWidget({
    super.key,
    this.onTap,
    this.radius = 20,
    this.clickable = true,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final imageUrl = userProvider.photo;
    final name = userProvider.name ?? '';

    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    Widget avatar;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(getStorageUrl(imageUrl)),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: radius * 0.9,
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return clickable ? GestureDetector(onTap: onTap, child: avatar) : avatar;
  }
}
