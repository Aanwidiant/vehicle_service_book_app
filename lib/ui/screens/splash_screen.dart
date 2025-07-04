import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_book_app/services/api_service.dart';
import 'package:vehicle_service_book_app/providers/user_provider.dart';
import 'package:vehicle_service_book_app/ui/widgets/hero_content_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      try {
        final response = await ApiService.get('/user');
        if (!mounted) return;

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final user = data['data'];

          context.read<UserProvider>().setUser(
            id: user['id'],
            name: user['name'],
            email: user['email'],
            photo: user['photo'] ?? '',
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          await prefs.remove('token');
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeroContentWidget(
              imagePath: 'assets/images/moto_track_hero_img.png',
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
