import 'package:flutter/material.dart';

class DdayCardTheme {
  final String id;
  final String name;
  final Gradient background;
  final Color textColor;
  final Color accentColor;
  final bool isPro;

  const DdayCardTheme({
    required this.id,
    required this.name,
    required this.background,
    required this.textColor,
    required this.accentColor,
    this.isPro = false,
  });
}
