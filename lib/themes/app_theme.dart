import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B1326);
  static const Color surface = Color(0xFF171F33);
  static const Color primary = Color(0xFFC3C0FF);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF6BD8CB);
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFC7C4D8);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      background: background,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: onSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Hanken Grotesk',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Hanken Grotesk',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: onSurface),
      bodyMedium: TextStyle(fontSize: 14, color: onSurfaceVariant),
    ),
    cardTheme: CardTheme(
      color: surface.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    ),
  );
}
