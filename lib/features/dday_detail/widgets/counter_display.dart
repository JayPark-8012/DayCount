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
    } else if (isCountUp || daysDiff < 0) {
      // Past date (count up)
      label = l10n.detail_daysSince(absDays);
      displayNumber = '+$absDays';
    } else {
      // Future date (countdown)
      label = l10n.detail_daysLeft(absDays);
      displayNumber = '$absDays';
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        // Emoji
        Text(
          emoji,
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 12),
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: theme.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Big number
        Text(
          displayNumber,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            letterSpacing: -3.0,
            color: theme.accentColor,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
