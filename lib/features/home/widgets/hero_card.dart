import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/widgets/card_pattern.dart';
import '../../../core/widgets/favorite_icon.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

class HeroCard extends StatelessWidget {
  final DDay dday;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteToggle;

  const HeroCard({
    super.key,
    required this.dday,
    this.onTap,
    this.onLongPress,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = getCardTheme(dday.themeId);
    final daysDiff = _calculateDaysDiff();

    return PressScale(
      onTap: onTap,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          height: AppConfig.heroCardMinHeight,
          decoration: BoxDecoration(
            gradient: theme.background,
            borderRadius: BorderRadius.circular(AppConfig.heroCardRadius),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : AppColors.primaryColor.withValues(alpha: 0.12),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConfig.heroCardRadius),
            child: Stack(
              children: [
                // Theme pattern
                CardPattern(
                  type: theme.pattern,
                  color: theme.accentColor,
                  opacity: 0.18,
                ),

                // Top accent line
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.accentColor,
                          theme.accentColor.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Favorite star — top right
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: FavoriteIcon(
                      isFavorite: dday.isFavorite,
                      size: 28,
                      inactiveColor: theme.textColor.withValues(alpha: 0.25),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(AppConfig.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji + title
                      Row(
                        children: [
                          Text(
                            dday.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: AppConfig.md),
                          Expanded(
                            child: Text(
                              dday.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: theme.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Day count + label
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _formatCount(daysDiff),
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w800,
                                      color: theme.accentColor,
                                      letterSpacing: -2.0,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatLabel(l10n, daysDiff),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textColor.withValues(alpha: 0.4),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppConfig.sm),
                          Text(
                            dday.targetDate,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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
          ),
        ),
      ),
    );
  }

  int _calculateDaysDiff() {
    final target = DateTime.parse(dday.targetDate);
    final now = DateUtils.dateOnly(DateTime.now());
    return target.difference(now).inDays;
  }

  String _formatCount(int daysDiff) {
    if (dday.isCountUp) {
      return daysDiff <= 0 ? '+${daysDiff.abs()}' : daysDiff.toString();
    }
    return daysDiff > 0 ? daysDiff.toString() : daysDiff.abs().toString();
  }

  String _formatLabel(AppLocalizations l10n, int daysDiff) {
    if (daysDiff == 0) return l10n.home_dDay;
    if (dday.isCountUp && daysDiff <= 0) {
      return l10n.home_daysAgo(daysDiff.abs());
    }
    if (daysDiff > 0) return l10n.home_daysLeft(daysDiff);
    return l10n.home_daysAgo(daysDiff.abs());
  }
}
