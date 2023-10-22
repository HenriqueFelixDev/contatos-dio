import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      colorSchemeSeed: const Color(0xFF1BA169),
      textTheme: GoogleFonts.cabinTextTheme(),
      dividerColor: const Color(0xFFD0D0D0),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFE5E5E5),
      ),
    );
  }
}