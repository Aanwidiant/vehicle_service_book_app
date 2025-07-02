import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/common/app_theme.dart';
import 'package:vehicle_service_book_app/ui/screens/dashboard_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/login_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/register_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/splash_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/welcome_screen.dart';

void main() {
  runApp(const VehicleServiceBookApp());
}

class VehicleServiceBookApp extends StatelessWidget {
  const VehicleServiceBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoTrack',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
