// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Constants
  static const Color _primary = Color(0xFF3EB489);    // Mint Green
  static const Color _secondary = Color(0xFF222831);  // Charcoal
  static const Color _lightBg = Color(0xFFF6F6F6);     // Soft neutral white
  static const Color _surface = Color(0xFFE0F2EF);     // Mint surface
  static const Color _darkBg = Color(0xFF1A1A1A);      // Deep charcoal
  static const Color _darkSurface = Color(0xFF2C2C2C);

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBg,
    primaryColor: _primary,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: _surface,
      onSurface: Colors.black,
      background: _lightBg,
      onBackground: Colors.black,
      error: Color(0xFFFF6B6B),
      onError: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primary),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBg,
    primaryColor: _primary,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.black,
    ),
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      onPrimary: Colors.black,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: _darkSurface,
      onSurface: Colors.white,
      background: _darkBg,
      onBackground: Colors.white,
      error: Color(0xFFFF6B6B),
      onError: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primary),
      ),
    ),
  );
}
