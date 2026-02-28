import 'package:flutter/material.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

class DdayCard extends StatefulWidget {
  final DDay dday;
  final int index;
  final VoidCallback? onTap;

  const DdayCard({
    super.key,
    required this.dday,
    required this.index,
    this.onTap,
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

    Future.delayed(AppConfig.cardStaggerDelay * widget.index, () {
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(AppConfig.lg),
          decoration: BoxDecoration(
            gradient: theme.background,
            borderRadius: BorderRadius.circular(AppConfig.cardRadius),
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: emoji + title + favorite
                  Row(
                    children: [
                      Text(
                        widget.dday.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: AppConfig.sm),
                      Expanded(
                        child: Text(
                          widget.dday.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.dday.isFavorite)
                        Text(
                          '\u{2B50}',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.accentColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConfig.md),
                  // Bottom row: date + days count
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.dday.targetDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textColor.withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatCount(daysDiff),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: theme.textColor,
                              letterSpacing: -1.0,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatLabel(l10n, daysDiff),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.textColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
