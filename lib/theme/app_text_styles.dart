import 'package:flutter/material.dart';

class AppTextStyles {
  static const String bodyFont = 'Inter';
  static const String headlineFont = 'Plus Jakarta Sans';
  static const String labelFont = 'JetBrains Mono';

  static TextTheme textTheme() {
    return const TextTheme(
      displaySmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        fontFamily: labelFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
      ),
    );
  }
}
