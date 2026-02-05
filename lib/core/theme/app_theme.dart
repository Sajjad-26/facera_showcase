import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Backgrounds
  static const Color deepObsidian = Color(0xFF0F1115); // Main Background
  static const Color surface = Color(0xFF1C1F26); // Primary Cards
  static const Color deepBlack = Color(0xFF000000);

  static const Color deepGreen = Color(0xFF0D1A0D); // Deep atmospheric green

  // Standard Background Gradient
  static const RadialGradient appGradient = RadialGradient(
    center: Alignment(-0.8, -0.8),
    radius: 1.8,
    colors: [deepGreen, deepObsidian, Colors.black],
    stops: [0.0, 0.4, 1.0],
  );

  // Accents (Glows & Highlights)
  static const Color electricLime = Color(0xFFC0FF02);
  static const Color accentPurple = Color(0xFFC0FF02); // Primary accent
  static const Color accentGold = Color(0xFFFACC15);
  static const Color accentCyan = Color(0xFF22D3EE);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary = Color(0xFF94A3B8); // Soft Grey
  static const Color textHint = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFFC0FF02);
  static const Color error = Color(0xFFEF4444);

  // Glass
  static const Color glass = Color(0x1AFFFFFF); // 10% White
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepObsidian,
      primaryColor: AppColors.electricLime,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricLime,
        secondary: AppColors.accentGold,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.black,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.outfit(color: AppColors.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.electricLime,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.electricLime,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
