import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/ui/widgets/greeting_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/main_scaffold_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/menu_card_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MainScaffoldWidget(
        title: 'Dashboard',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
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
                GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MenuCardWidget(
                      icon: Icons.directions_car,
                      label: 'Kendaraanku',
                      onTap: () {
                        Navigator.pushNamed(context, '/vehicle');
                      },
                    ),
                    MenuCardWidget(
                      icon: Icons.history,
                      label: 'Riwayat Servis',
                      onTap: () {
                        Navigator.pushNamed(context, '/service');
                      },
                    ),
                    MenuCardWidget(
                      icon: Icons.notifications_active,
                      label: 'Pengingat Servis',
                      onTap: () {
                        Navigator.pushNamed(context, '/reminder');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
