import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_service_book_app/ui/widgets/profile_avatar_widget.dart';

class UserMenuWidget extends StatelessWidget {
  final bool showProfileOption;

  const UserMenuWidget({super.key, this.showProfileOption = true});

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu Pengguna',
      position: PopupMenuPosition.under,
      onSelected: (value) {
        switch (value) {
          case 'profile':
            Navigator.pushNamed(context, '/profile');
            break;
          case 'logout':
            _handleLogout(context);
            break;
        }
      },
      itemBuilder: (context) => [
        if (showProfileOption)
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: const [
                Icon(Icons.person, color: Colors.black54),
                SizedBox(width: 8),
                Text('Profil'),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Keluar'),
            ],
          ),
        ),
      ],
      child: const ProfileAvatarWidget(),
    );
  }
}
