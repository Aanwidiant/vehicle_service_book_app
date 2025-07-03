import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  State<GreetingWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  String userName = '';
  String greeting = '';
  String currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateTime(); // initial call
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? 'User';

    final hour = DateTime.now().hour;
    String timeGreeting;
    if (hour >= 5 && hour < 12) {
      timeGreeting = 'Selamat pagi';
    } else if (hour >= 12 && hour < 15) {
      timeGreeting = 'Selamat siang';
    } else if (hour >= 15 && hour < 18) {
      timeGreeting = 'Selamat sore';
    } else {
      timeGreeting = 'Selamat malam';
    }

    if (!mounted) return;
    setState(() {
      userName = name;
      greeting = timeGreeting;
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatted = DateFormat('EEEE, dd MMMM yyyy • HH:mm').format(now);

    if (!mounted) return;
    setState(() {
      currentTime = formatted;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName!',
          style: t.titleLarge?.copyWith(
            color: c.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text('Selamat datang di MotoTrack', style: t.bodyMedium),
        Text('Semoga hari Anda menyenangkan.', style: t.bodyMedium),
        const SizedBox(height: 8),
        Text(
          currentTime,
          style: t.titleLarge?.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
