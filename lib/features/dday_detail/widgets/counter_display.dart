import 'package:flutter/material.dart';

import '../../../data/models/card_theme.dart';
import '../../../l10n/app_localizations.dart';

class CounterDisplay extends StatelessWidget {
  final String emoji;
  final String title;
  final int daysDiff;
  final bool isCountUp;
  final DdayCardTheme theme;

  const CounterDisplay({
    super.key,
    required this.emoji,
    required this.title,
    required this.daysDiff,
    required this.isCountUp,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final absDays = daysDiff.abs();

    final String label;
    final String displayNumber;

    if (daysDiff == 0) {
      label = l10n.detail_dDay;
      displayNumber = '0';
    } else if (daysDiff > 0) {
      label = l10n.detail_daysLeft(absDays);
      displayNumber = '$absDays';
    } else {
      label = l10n.detail_daysSince(absDays);
      displayNumber = '+$absDays';
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        // Emoji — 52pt with drop-shadow
        Text(
          emoji,
          style: const TextStyle(
            fontSize: 52,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Title — 20pt w700, letterSpacing -0.3
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: theme.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Big number — 80pt w800, letterSpacing -4, drop-shadow
        Text(
          displayNumber,
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w800,
            letterSpacing: -4.0,
            color: theme.accentColor,
            height: 1.0,
            shadows: [
              Shadow(
                color: theme.accentColor.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Label — 14pt, opacity 0.4, letterSpacing 1
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
            color: theme.textColor.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
