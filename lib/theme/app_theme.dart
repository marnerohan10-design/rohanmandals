import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color offWhite = Color(0xFFFAF7F2);
  static const Color plum = Color(0xFF3B1F2B);
  static const Color rust = Color(0xFF8C5A4A);
  static const Color gold = Color(0xFFC9A227);
  static const Color parchment = Color(0xFFE8DCC8);
  static const Color charcoal = Color(0xFF2A2421);
  static const Color mutedText = Color(0xFF5E514C);

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: offWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: plum,
        brightness: Brightness.light,
        primary: plum,
        secondary: rust,
        tertiary: gold,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w600,
          color: plum,
        ),
        bodyLarge: GoogleFonts.inter(color: charcoal),
        bodyMedium: GoogleFonts.inter(color: charcoal),
        bodySmall: GoogleFonts.inter(color: mutedText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: offWhite,
        foregroundColor: plum,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEEE4D8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEEE4D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: plum, width: 1.5),
        ),
      ),
    );
    return base;
  }
}
