import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/app_spacing.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: Row(
        children: [
          _GlassChip(
            value: '$months',
            label: l10n.detail_months,
            theme: theme,
          ),
          const SizedBox(width: 14),
          _GlassChip(
            value: '$weeks',
            label: l10n.detail_weeks,
            theme: theme,
          ),
          const SizedBox(width: 14),
          _GlassChip(
            value: '$absDays',
            label: l10n.detail_days,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final String value;
  final String label;
  final DdayCardTheme theme;

  const _GlassChip({
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConfig.detailSubCountRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            constraints: const BoxConstraints(minWidth: 74),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
            decoration: BoxDecoration(
              color: theme.textColor.withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(AppConfig.detailSubCountRadius),
              border: Border.all(
                color: theme.textColor.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              children: [
                // Number — 24pt w800
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    color: theme.accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                // Label — 10pt opacity 0.4, letterSpacing 0.5
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: theme.textColor.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
