import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_service_book_app/ui/screens/my_vehicles_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/service_history_screen.dart';
import 'package:vehicle_service_book_app/ui/screens/service_reminder_screen.dart';
import 'package:vehicle_service_book_app/ui/widgets/greeting_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/menu_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MainScaffoldWidget(
        title: 'Dashboard',
        userName: userName,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingWidget(),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Mulai jelajahi fitur MotoTrack',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    MenuCardWidget(
                      icon: Icons.directions_car,
                      label: 'Kendaraanku',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyVehiclesScreen(),
                          ),
                        );
                      },
                    ),
                    MenuCardWidget(
                      icon: Icons.history,
                      label: 'Riwayat Servis',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    MenuCardWidget(
                      icon: Icons.notifications_active,
                      label: 'Pengingat Servis',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceReminderScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
