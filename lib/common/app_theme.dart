import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFD32F2F),
    onPrimary: Colors.white,
    secondary: Color(0xFFFFC107),
    onSecondary: Colors.black,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFD32F2F),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD32F2F),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFD32F2F)),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    labelStyle: const TextStyle(color: Color(0xFFD32F2F)),
  ),
  textTheme: GoogleFonts.nunitoTextTheme(
    const TextTheme(
      bodySmall: TextStyle(fontSize: 15, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 19, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 17, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.red.withValues(alpha: 0.75),
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
