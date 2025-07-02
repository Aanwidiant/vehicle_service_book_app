import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable back gesture dan tombol back
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false, // Hilangkan ikon back di AppBar
        ),
        body: const Center(
          child: Text('Selamat datang di Dashboard!'),
        ),
      ),
    );
  }
}
