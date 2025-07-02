import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/ui/widgets/custom_button_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/hero_content_widget.dart';
import 'package:vehicle_service_book_app/ui/widgets/logo_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorScheme.surface,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HeroContentWidget(
                      imagePath: 'assets/images/washing_machine.png',
                    ),
                    const SizedBox(height: 32),
                    CustomButtonWidget(
                      text: 'Register',
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 96,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 153,
                                ), // ✅ 0.6 * 255 = 153
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                    ),
                    CustomButtonWidget(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
              const Positioned(top: 0, right: 0, child: LogoWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
