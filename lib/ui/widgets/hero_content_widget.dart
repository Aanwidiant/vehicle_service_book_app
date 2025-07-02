import 'package:flutter/material.dart';

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
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          SizedBox(
            width: 240,
            child: Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Track',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Image.asset(imagePath, width: 240, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
