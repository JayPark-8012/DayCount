import 'package:flutter/material.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/utils/date_calc.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

/// 1:1 square card preview for the share screen.
/// Wrapped with [RepaintBoundary] for PNG capture.
class CardPreview extends StatelessWidget {
  final GlobalKey cardKey;
  final DDay dday;
  final String themeId;

  const CardPreview({
    super.key,
    required this.cardKey,
    required this.dday,
    required this.themeId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = getCardTheme(themeId);
    final targetDate = DateTime.parse(dday.targetDate);
    final diff = daysDiff(targetDate, today());

    final dayCount = _formatDayCount(l10n, diff);
    final subtitle = _formatSubtitle(l10n, diff, dday.category);

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: theme.background,
          borderRadius: BorderRadius.circular(AppConfig.shareCardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative circle — top right
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.accentColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Decorative circle — bottom left
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.accentColor.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dday.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dday.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dayCount,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: theme.accentColor,
                      letterSpacing: -3.0,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Watermark
            Positioned(
              right: 20,
              bottom: 16,
              child: Text(
                l10n.common_appName,
                style: TextStyle(
                  fontSize: 10,
                  color: theme.textColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDayCount(AppLocalizations l10n, int diff) {
    if (diff == 0) return l10n.share_dDay;
    if (diff > 0) return '$diff';
    return '+${diff.abs()}';
  }

  String _formatSubtitle(AppLocalizations l10n, int diff, String category) {
    if (diff == 0) return l10n.share_today;
    if (diff > 0) return l10n.share_daysLeft;
    if (category == 'couple') return l10n.share_daysTogether;
    return l10n.share_daysSince;
  }
}
