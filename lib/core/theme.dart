// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

class CivicTheme {
  // ── Breakpoints ─────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  /// Responsive column count for card grids.
  static int gridColumns(double width) {
    if (width >= tabletBreakpoint) return 4;
    if (width >= mobileBreakpoint) return 3;
    return 2;
  }

  /// Max content width for centering on large screens.
  static const double maxContentWidth = 700;

  static ThemeData get darkTheme {
    const primaryGreen = Color(0xFF4CAF50);
    const accentTeal = Color(0xFF03DAC6);
    const surface = Color(0xFF1E1E1E);
    const scaffoldBg = Color(0xFF121212);
    const onSurface = Colors.white;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: accentTeal,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: onSurface,
      ),

      // ── Typography ──────────────────────────────────────────
      textTheme: const TextTheme(
        displaySmall: TextStyle(
            color: onSurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.3),
        headlineSmall: TextStyle(
            color: onSurface,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.3),
        titleLarge: TextStyle(
            color: onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.3),
        titleMedium: TextStyle(
            color: onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.4),
        titleSmall: TextStyle(
            color: onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.4),
        bodyLarge: TextStyle(color: onSurface, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
        labelLarge: TextStyle(
            color: onSurface, fontSize: 14, fontWeight: FontWeight.w600),
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),

      // ── Input Fields ────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      ),

      // ── Buttons ─────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: primaryGreen.withAlpha(100)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),

      // ── Card Theme ──────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Focus / Selection ───────────────────────────────────
      focusColor: primaryGreen.withAlpha(40),
      hoverColor: primaryGreen.withAlpha(20),
      splashColor: primaryGreen.withAlpha(30),
    );
  }
}
