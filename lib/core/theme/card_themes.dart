import 'package:flutter/material.dart';

import '../../data/models/card_theme.dart';

LinearGradient _grad(Color start, Color end) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [start, end],
    );

final Map<String, DdayCardTheme> cardThemes = {
  // --- Free (6) ---
  'cloud': DdayCardTheme(
    id: 'cloud',
    name: 'Cloud',
    background: _grad(const Color(0xFFF0F0FF), const Color(0xFFE8E8FF)),
    textColor: const Color(0xFF2D2D3F),
    accentColor: const Color(0xFF6C63FF),
  ),
  'sunset': DdayCardTheme(
    id: 'sunset',
    name: 'Sunset',
    background: _grad(const Color(0xFFFFF0E6), const Color(0xFFFFE0CC)),
    textColor: const Color(0xFF8B4513),
    accentColor: const Color(0xFFFF6B3D),
  ),
  'ocean': DdayCardTheme(
    id: 'ocean',
    name: 'Ocean',
    background: _grad(const Color(0xFFE6F5FF), const Color(0xFFCCE8FF)),
    textColor: const Color(0xFF1A5276),
    accentColor: const Color(0xFF2E86DE),
  ),
  'forest': DdayCardTheme(
    id: 'forest',
    name: 'Forest',
    background: _grad(const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)),
    textColor: const Color(0xFF1B5E20),
    accentColor: const Color(0xFF43A047),
  ),
  'lavender': DdayCardTheme(
    id: 'lavender',
    name: 'Lavender',
    background: _grad(const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)),
    textColor: const Color(0xFF4A148C),
    accentColor: const Color(0xFF9C27B0),
  ),
  'minimal': DdayCardTheme(
    id: 'minimal',
    name: 'Minimal',
    background: _grad(const Color(0xFFFFFFFF), const Color(0xFFF5F5F5)),
    textColor: const Color(0xFF212121),
    accentColor: const Color(0xFF6C63FF),
  ),

  // --- Premium (15) ---
  'midnight': DdayCardTheme(
    id: 'midnight',
    name: 'Midnight',
    background: _grad(const Color(0xFF1A1A2E), const Color(0xFF16213E)),
    textColor: const Color(0xFFE8E8FF),
    accentColor: const Color(0xFF6C63FF),
    isPro: true,
  ),
  'cherry': DdayCardTheme(
    id: 'cherry',
    name: 'Cherry',
    background: _grad(const Color(0xFFB71C1C), const Color(0xFFE53935)),
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFFCDD2),
    isPro: true,
  ),
  'aurora': DdayCardTheme(
    id: 'aurora',
    name: 'Aurora',
    background: _grad(const Color(0xFF0F2027), const Color(0xFF2C5364)),
    textColor: const Color(0xFF43E8D8),
    accentColor: const Color(0xFF43E8D8),
    isPro: true,
  ),
  'peach': DdayCardTheme(
    id: 'peach',
    name: 'Peach',
    background: _grad(const Color(0xFFFFECD2), const Color(0xFFFCB69F)),
    textColor: const Color(0xFF5D4037),
    accentColor: const Color(0xFFFF7043),
    isPro: true,
  ),
  'noir': DdayCardTheme(
    id: 'noir',
    name: 'Noir',
    background: _grad(const Color(0xFF232526), const Color(0xFF414345)),
    textColor: const Color(0xFFFAFAFA),
    accentColor: const Color(0xFFFFD700),
    isPro: true,
  ),
  'rosegold': DdayCardTheme(
    id: 'rosegold',
    name: 'Rose Gold',
    background: _grad(const Color(0xFFF4C4C4), const Color(0xFFE8A8A8)),
    textColor: const Color(0xFF5D3A3A),
    accentColor: const Color(0xFFC97B7B),
    isPro: true,
  ),
  'arctic': DdayCardTheme(
    id: 'arctic',
    name: 'Arctic',
    background: _grad(const Color(0xFFE0F2F7), const Color(0xFFB2E0F0)),
    textColor: const Color(0xFF0D3B66),
    accentColor: const Color(0xFF1E88E5),
    isPro: true,
  ),
  'ember': DdayCardTheme(
    id: 'ember',
    name: 'Ember',
    background: _grad(const Color(0xFFFF8A65), const Color(0xFFFF5722)),
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFFE0B2),
    isPro: true,
  ),
  'sage': DdayCardTheme(
    id: 'sage',
    name: 'Sage',
    background: _grad(const Color(0xFFD5E1D5), const Color(0xFFB5C9B5)),
    textColor: const Color(0xFF2E4A2E),
    accentColor: const Color(0xFF5C8A5C),
    isPro: true,
  ),
  'twilight': DdayCardTheme(
    id: 'twilight',
    name: 'Twilight',
    background: _grad(const Color(0xFF2D1B69), const Color(0xFF1A1A4E)),
    textColor: const Color(0xFFD4C5FF),
    accentColor: const Color(0xFFB39DDB),
    isPro: true,
  ),
  'mocha': DdayCardTheme(
    id: 'mocha',
    name: 'Mocha',
    background: _grad(const Color(0xFFD7CCC8), const Color(0xFFBCAAA4)),
    textColor: const Color(0xFF3E2723),
    accentColor: const Color(0xFF795548),
    isPro: true,
  ),
  'ocean_deep': DdayCardTheme(
    id: 'ocean_deep',
    name: 'Ocean Deep',
    background: _grad(const Color(0xFF0D1B2A), const Color(0xFF1B3A4B)),
    textColor: const Color(0xFFA8D8EA),
    accentColor: const Color(0xFF48CAE4),
    isPro: true,
  ),
  'cotton_candy': DdayCardTheme(
    id: 'cotton_candy',
    name: 'Cotton Candy',
    background: _grad(const Color(0xFFF8BBD0), const Color(0xFFCE93D8)),
    textColor: const Color(0xFF4A148C),
    accentColor: const Color(0xFFE040FB),
    isPro: true,
  ),
  'graphite': DdayCardTheme(
    id: 'graphite',
    name: 'Graphite',
    background: _grad(const Color(0xFF37474F), const Color(0xFF546E7A)),
    textColor: const Color(0xFFECEFF1),
    accentColor: const Color(0xFF90A4AE),
    isPro: true,
  ),
  'royal': DdayCardTheme(
    id: 'royal',
    name: 'Royal',
    background: _grad(const Color(0xFF1A237E), const Color(0xFF283593)),
    textColor: const Color(0xFFE8EAF6),
    accentColor: const Color(0xFFFFD700),
    isPro: true,
  ),
};

DdayCardTheme getCardTheme(String themeId) {
  return cardThemes[themeId] ?? cardThemes['cloud']!;
}
