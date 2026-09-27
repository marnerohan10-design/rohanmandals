import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color offWhite = Color(0xFFFFFFFF);
  static const Color plum = Color(0xFF1B2925);
  static const Color rust = Color(0xFFFFC107);
  static const Color gold = Color(0xFFFFB300);
  static const Color parchment = Color(0xFFE7F5F1);
  static const Color charcoal = Color(0xFF1B2925);
  static const Color mutedText = Color(0xFF6A7773);
  static const Color line = Color(0xFFDCE9E5);

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: offWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rust,
        brightness: Brightness.light,
        primary: plum,
        secondary: rust,
        tertiary: gold,
        surface: offWhite,
      ),
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w700,
          color: plum,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w600,
          color: plum,
        ),
        bodyLarge: GoogleFonts.dmSans(color: charcoal),
        bodyMedium: GoogleFonts.dmSans(color: charcoal),
        bodySmall: GoogleFonts.dmSans(color: mutedText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: offWhite,
        foregroundColor: charcoal,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: parchment,
        elevation: 8,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: charcoal),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: rust,
          foregroundColor: plum,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: rust,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: plum, width: 1.5),
        ),
      ),
    );
    return base;
  }
}
