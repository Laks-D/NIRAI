import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NiraiTheme {
  static const Color background = Color(0xFFF2EFE9); // Ivory
  static const Color primary = Color(0xFF2F4F4F); // Slate
  static const Color accent = Color(0xFFFFD700); // Bold Yellow

  static const double radiusCard = 24.0;
  static const double radiusPill = 999.0;

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        primary: primary,
        secondary: accent,
        surface: background,
      ),
    );

    final header = GoogleFonts.playfairDisplay(
      color: primary,
      fontWeight: FontWeight.w600,
    );
    final body = GoogleFonts.inter(
      color: primary,
      fontWeight: FontWeight.w500,
    );

    return base.copyWith(
      textTheme: TextTheme(
        headlineLarge: header.copyWith(fontSize: 28, height: 1.1),
        headlineMedium: header.copyWith(fontSize: 22, height: 1.15),
        titleMedium: header.copyWith(fontSize: 16, height: 1.2),
        bodyLarge: body.copyWith(fontSize: 16, height: 1.35),
        bodyMedium: body.copyWith(fontSize: 14, height: 1.35),
        labelLarge: body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  static List<BoxShadow> cardShadow() => const [
        BoxShadow(
          color: Color(0x1F2F4F4F),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ];
}
