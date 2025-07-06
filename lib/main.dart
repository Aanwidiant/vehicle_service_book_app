import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_book_app/common/app_theme.dart';
import 'package:vehicle_service_book_app/providers/user_provider.dart';
import 'package:vehicle_service_book_app/ui/screens/add_vehicle_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/dashboard_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/detail_vehicle_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/edit_profile_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/edit_vehicle_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/login_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/my_vehicles_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/profile_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/register_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/service_history_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/service_reminder_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/splash_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const VehicleServiceBookApp(),
    ),
  );
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
        '/profile': (context) => const ProfileScreen(),
        '/profile/edit': (context) => const EditProfileScreen(),
        '/vehicle': (context) => const MyVehiclesScreen(),
        '/vehicle/add': (context) => const AddVehicleScreen(),
        '/vehicle/edit': (context) => const EditVehicleScreen(),
        '/vehicle/detail': (context) => const DetailVehicleScreen(),
        '/service': (context) => const ServiceHistoryScreen(),
        '/reminder': (context) => const ServiceReminderScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
