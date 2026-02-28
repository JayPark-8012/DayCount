import 'package:flutter/material.dart';

import '../../../core/constants/app_config.dart';
import '../../../data/models/card_theme.dart';
import '../../../l10n/app_localizations.dart';

class SubCounts extends StatelessWidget {
  final int totalDays;
  final DdayCardTheme theme;

  const SubCounts({
    super.key,
    required this.totalDays,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final absDays = totalDays.abs();
    final months = absDays ~/ 30;
    final weeks = absDays ~/ 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
      child: Row(
        children: [
          _SubCountCard(
            value: '$months',
            label: l10n.detail_months,
            theme: theme,
          ),
          const SizedBox(width: AppConfig.sm),
          _SubCountCard(
            value: '$weeks',
            label: l10n.detail_weeks,
            theme: theme,
          ),
          const SizedBox(width: AppConfig.sm),
          _SubCountCard(
            value: '$absDays',
            label: l10n.detail_days,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SubCountCard extends StatelessWidget {
  final String value;
  final String label;
  final DdayCardTheme theme;

  const _SubCountCard({
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.textColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: theme.accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
