import 'package:flutter/material.dart';

enum CardPatternType { circles, waves, leaves, stars, petals, aurora }

class DdayCardTheme {
  final String id;
  final String name;
  final Gradient background;
  final Color textColor;
  final Color accentColor;
  final bool isPro;
  final CardPatternType pattern;

  const DdayCardTheme({
    required this.id,
    required this.name,
    required this.background,
    required this.textColor,
    required this.accentColor,
    this.isPro = false,
    this.pattern = CardPatternType.circles,
  });
}
