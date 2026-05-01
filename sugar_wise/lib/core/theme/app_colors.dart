import 'package:flutter/material.dart';

/// Sugar Wise Design System V2 - Brand Color Palette
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // 🎨 Brand Colors
  // ─────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF2DA1D7);
  static const Color brandGreen = Color(0xFF8EC641);

  // ─────────────────────────────────────────────
  // ☀️ Light Mode
  // ─────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // ─────────────────────────────────────────────
  // 🌙 Dark Mode
  // ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkDeep = Color(0xFF030712);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // ─────────────────────────────────────────────
  // ✅ Semantic Colors
  // ─────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);       // Light mode
  static const Color successDark = Color(0xFF4ADE80);   // Dark mode
  static const Color warning = Color(0xFFCA8A04);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEE2E2);

  // ─────────────────────────────────────────────
  // 🔤 Legacy aliases (for doctor_home compatibility)
  // ─────────────────────────────────────────────
  static const Color textMain = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);
  static const Color scaffoldBackground = Color(0xFFF4F6F9);

  // ─────────────────────────────────────────────
  // 🌈 Gradients
  // ─────────────────────────────────────────────
  static const LinearGradient heroPrimary = LinearGradient(
    colors: [primaryBlue, brandGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentHealth = LinearGradient(
    colors: [brandGreen, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────
  // 💡 Utility helpers
  // ─────────────────────────────────────────────

  /// Returns surface color based on theme brightness
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;

  /// Returns background color based on theme brightness
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  /// Returns primary text color based on theme brightness
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;

  /// Returns secondary text color based on theme brightness
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextSecondary
          : lightTextSecondary;

  /// Returns border color based on theme brightness
  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : lightBorder;

  // Dashboard card accent colors — based on brand palette
  static const List<Color> cardAccents = [
    primaryBlue,       // Blue
    brandGreen,        // Green
    Color(0xFF16A34A), // Success Green
    Color(0xFFCA8A04), // Warning Yellow
    Color(0xFFDC2626), // Danger Red
    Color(0xFF0369A1), // Deep Blue
  ];
}
