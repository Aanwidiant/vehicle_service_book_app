import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroContentWidget extends StatelessWidget {
  final String imagePath;

  const HeroContentWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: Text(
              'Moto',
              style: GoogleFonts.bebasNeue(
                fontSize: 64,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          SizedBox(
            width: 240,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Track',
                style: GoogleFonts.orbitron(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Image.asset(imagePath, width: 240, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
