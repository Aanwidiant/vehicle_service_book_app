import 'package:flutter/material.dart';

class ServiceReminderScreen extends StatelessWidget {
  const ServiceReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengingat Servis')),
      body: const Center(child: Text('Halaman Pengingat Servis')),
    );
  }
}
