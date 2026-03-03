import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/widgets/card_pattern.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

class DdayCard extends StatefulWidget {
  final DDay dday;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DdayCard({
    super.key,
    required this.dday,
    required this.index,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<DdayCard> createState() => _DdayCardState();
}

class _DdayCardState extends State<DdayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConfig.cardAnimDuration,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 16),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    final clampedIndex = widget.index.clamp(0, 10);
    Future.delayed(AppConfig.staggerDelay * clampedIndex, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = getCardTheme(widget.dday.themeId);
    final daysDiff = _calculateDaysDiff();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: _slideAnim.value,
            child: child,
          ),
        );
      },
      child: PressScale(
        onTap: widget.onTap,
        child: GestureDetector(
          onLongPress: widget.onLongPress,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              gradient: theme.background,
              borderRadius:
                  BorderRadius.circular(AppConfig.listCardRadius),
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
                // Theme pattern
                CardPattern(
                  type: theme.pattern,
                  color: theme.accentColor,
                  opacity: 0.12,
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),
                  child: Row(
                    children: [
                      // Emoji
                      Text(
                        widget.dday.emoji,
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
                              widget.dday.title,
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
                              widget.dday.targetDate,
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
                      // Day count — constrained to prevent right overflow
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _formatCount(daysDiff),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: theme.accentColor,
                                  letterSpacing: -1.0,
                                  height: 1.0,
                                ),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
    final target = DateTime.parse(widget.dday.targetDate);
    final now = DateUtils.dateOnly(DateTime.now());
    return target.difference(now).inDays;
  }

  String _formatCount(int daysDiff) {
    if (widget.dday.isCountUp) {
      return daysDiff <= 0 ? '+${daysDiff.abs()}' : daysDiff.toString();
    }
    return daysDiff > 0 ? daysDiff.toString() : daysDiff.abs().toString();
  }

  String _formatLabel(AppLocalizations l10n, int daysDiff) {
    if (daysDiff == 0) return l10n.home_dDay;
    if (widget.dday.isCountUp && daysDiff <= 0) {
      return l10n.home_daysAgo(daysDiff.abs());
    }
    if (daysDiff > 0) return l10n.home_daysLeft(daysDiff);
    return l10n.home_daysAgo(daysDiff.abs());
  }
}
