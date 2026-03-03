import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/widgets/card_pattern.dart';
import '../../../l10n/app_localizations.dart';

/// Live preview card matching the home list card layout.
/// Shows selected emoji, title, theme, and computed day count.
class PreviewCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String themeId;
  final DateTime targetDate;

  const PreviewCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.themeId,
    required this.targetDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = getCardTheme(themeId);
    final daysDiff = _calculateDaysDiff();

    final displayTitle = title.isEmpty ? '...' : title;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: theme.background,
        borderRadius: BorderRadius.circular(AppConfig.listCardRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          CardPattern(
            type: theme.pattern,
            color: theme.accentColor,
            opacity: 0.20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Row(
        children: [
          // Emoji
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppConfig.md),
          // Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: theme.textColor.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConfig.sm),
          // Day count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatCount(daysDiff),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: theme.accentColor,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatLabel(l10n, daysDiff),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysDiff() {
    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(targetDate);
    return target.difference(now).inDays;
  }

  bool _isCountUp() {
    final now = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(targetDate);
    return !target.isAfter(now);
  }

  String _formatDate() {
    final y = targetDate.year.toString();
    final m = targetDate.month.toString().padLeft(2, '0');
    final d = targetDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatCount(int daysDiff) {
    final isCountUp = _isCountUp();
    if (isCountUp) {
      return daysDiff <= 0 ? '+${daysDiff.abs()}' : daysDiff.toString();
    }
    return daysDiff > 0 ? daysDiff.toString() : daysDiff.abs().toString();
  }

  String _formatLabel(AppLocalizations l10n, int daysDiff) {
    if (daysDiff == 0) return l10n.home_dDay;
    final isCountUp = _isCountUp();
    if (isCountUp && daysDiff <= 0) {
      return l10n.home_daysAgo(daysDiff.abs());
    }
    if (daysDiff > 0) return l10n.home_daysLeft(daysDiff);
    return l10n.home_daysAgo(daysDiff.abs());
  }
}
