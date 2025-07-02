import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Image.asset(
          'assets/images/logo_clean_loundry.png',
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
