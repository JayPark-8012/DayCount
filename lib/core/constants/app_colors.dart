import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const primaryColor = Color(0xFF6C63FF);
  static const secondaryColor = Color(0xFFFF6B8A);
  static const accentColor = Color(0xFF43E8D8);

  // Light mode
  static const backgroundLight = Color(0xFFFAFAFA);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const textPrimaryLight = Color(0xFF1A1A2E);
  static const textSecondaryLight = Color(0xFF666666);
  static const textDisabledLight = Color(0xFF999999);
  static const dividerLight = Color(0xFFE8E8F0);

  // Dark mode
  static const backgroundDark = Color(0xFF1A1A2E);
  static const surfaceDark = Color(0xFF252542);
  static const textPrimaryDark = Color(0xFFE8E8FF);
  static const textSecondaryDark = Color(0xFFA0A0C0);
  static const textDisabledDark = Color(0xFF666680);
  static const dividerDark = Color(0xFF3A3A5C);

  // Status (light)
  static const errorColor = Color(0xFFE53935);
  static const successColor = Color(0xFF43A047);

  // Status (dark)
  static const errorColorDark = Color(0xFFEF5350);
  static const successColorDark = Color(0xFF66BB6A);

  // Gradients
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
  );

  static const logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFFFF6B8A)],
  );

  // Appbar icon button backgrounds
  static const iconButtonLight = Color(0xFFF0F0F5);
  static const iconButtonDark = Color(0xFF252542);
}
