import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/widgets/card_pattern.dart';
import '../../../core/widgets/favorite_icon.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../data/models/card_theme.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

class TimelineNode extends StatefulWidget {
  final DDay dday;
  final int index;
  final bool isPast;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const TimelineNode({
    super.key,
    required this.dday,
    required this.index,
    required this.isPast,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<TimelineNode>
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
    Future.delayed(AppConfig.timelineStaggerDelay * clampedIndex, () {
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
    final theme = getCardTheme(widget.dday.themeId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      child: CustomPaint(
        painter: _TimelineLinePainter(
          isFirst: widget.isFirst,
          isLast: widget.isLast,
          markerColor: _markerColor(isDark),
          lineColor: AppColors.primaryColor,
          bgColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          emoji: widget.dday.emoji,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: _buildCard(context, theme),
          ),
        ),
      ),
    );
  }

  Color _markerColor(bool isDark) {
    final target = DateTime.parse(widget.dday.targetDate);
    final today = DateUtils.dateOnly(DateTime.now());
    if (target.isAtSameMomentAs(today)) return AppColors.primaryColor;
    if (widget.isPast) {
      return isDark ? AppColors.textSecondaryDark : Colors.grey.shade400;
    }
    return AppColors.accentColor;
  }

  Widget _buildCard(BuildContext context, DdayCardTheme theme) {
    final l10n = AppLocalizations.of(context)!;
    final daysDiff = _calculateDaysDiff();

    return PressScale(
      onTap: widget.onTap,
      child: Opacity(
        opacity: widget.isPast ? 0.45 : 1.0,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: theme.background,
            borderRadius:
                BorderRadius.circular(AppConfig.milestoneCardRadius),
          ),
          child: Stack(
            children: [
              // Theme pattern
              CardPattern(
                type: theme.pattern,
                color: theme.accentColor,
                opacity: 0.10,
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConfig.lg,
                  vertical: AppConfig.md,
                ),
                child: Row(
                  children: [
                    // Emoji
                    Text(
                      widget.dday.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: AppConfig.md),
                    // Title + Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.dday.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: theme.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              FavoriteIcon(
                                isFavorite: widget.dday.isFavorite,
                                size: 16,
                                inactiveColor: theme.textColor.withValues(alpha: 0.15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.dday.targetDate,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.textColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConfig.sm),
                    // Day count — constrained to prevent right overflow
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatCount(l10n, daysDiff),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: theme.accentColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

  String _formatCount(AppLocalizations l10n, int daysDiff) {
    if (daysDiff == 0) return l10n.home_dDay;
    if (daysDiff > 0) return '$daysDiff';
    return '+${daysDiff.abs()}';
  }
}

class _TimelineLinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color markerColor;
  final Color lineColor;
  final Color bgColor;
  final String emoji;

  _TimelineLinePainter({
    required this.isFirst,
    required this.isLast,
    required this.markerColor,
    required this.lineColor,
    required this.bgColor,
    required this.emoji,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    const centerX = 20.0;
    final centerY = size.height / 2;
    const markerRadius = 12.0;

    // Top line
    if (!isFirst) {
      final topRect = Rect.fromLTWH(centerX - 1, 0, 2, centerY - markerRadius);
      canvas.drawRect(
        topRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.15),
              lineColor.withValues(alpha: 0.3),
            ],
          ).createShader(topRect),
      );
    }

    // Bottom line
    if (!isLast) {
      final bottomTop = centerY + markerRadius;
      final bottomRect =
          Rect.fromLTWH(centerX - 1, bottomTop, 2, size.height - bottomTop);
      canvas.drawRect(
        bottomRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.3),
              lineColor.withValues(alpha: 0.15),
            ],
          ).createShader(bottomRect),
      );
    }

    // Marker circle background
    canvas.drawCircle(
      Offset(centerX, centerY),
      markerRadius,
      Paint()..color = markerColor,
    );

    // Marker border
    canvas.drawCircle(
      Offset(centerX, centerY),
      markerRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = bgColor,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineLinePainter old) {
    return isFirst != old.isFirst ||
        isLast != old.isLast ||
        markerColor != old.markerColor ||
        bgColor != old.bgColor;
  }
}
