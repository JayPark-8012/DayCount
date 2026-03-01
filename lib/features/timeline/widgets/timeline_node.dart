import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../data/models/dday.dart';
import '../../../data/models/card_theme.dart';

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

    Future.delayed(AppConfig.timelineStaggerDelay * widget.index, () {
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
    final lineColor = (isDark ? AppColors.textSecondaryDark : AppColors.primaryColor)
        .withValues(alpha: 0.3);

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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: timeline line + marker
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Top line
                  Expanded(
                    child: widget.isFirst
                        ? const SizedBox.shrink()
                        : Center(
                            child: Container(
                              width: 2,
                              color: lineColor,
                            ),
                          ),
                  ),
                  // Marker dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _markerColor,
                    ),
                  ),
                  // Bottom line
                  Expanded(
                    child: widget.isLast
                        ? const SizedBox.shrink()
                        : Center(
                            child: Container(
                              width: 2,
                              color: lineColor,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConfig.md),
            // Right: card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppConfig.xs),
                child: _buildCard(context, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _markerColor {
    final target = DateTime.parse(widget.dday.targetDate);
    final today = DateUtils.dateOnly(DateTime.now());
    if (target.isAtSameMomentAs(today)) return AppColors.primaryColor;
    if (widget.isPast) return Colors.grey.shade400;
    return AppColors.accentColor;
  }

  Widget _buildCard(BuildContext context, DdayCardTheme theme) {
    final daysDiff = _calculateDaysDiff();

    return GestureDetector(
      onTap: widget.onTap,
      child: Opacity(
        opacity: widget.isPast ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConfig.lg,
            vertical: AppConfig.md,
          ),
          decoration: BoxDecoration(
            gradient: theme.background,
            borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
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
                    Text(
                      widget.dday.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              // Day count
              Text(
                _formatCount(daysDiff),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.accentColor,
                  letterSpacing: -0.5,
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

  String _formatCount(int daysDiff) {
    if (daysDiff == 0) return 'D-Day';
    if (daysDiff > 0) return '$daysDiff';
    return '+${daysDiff.abs()}';
  }
}
