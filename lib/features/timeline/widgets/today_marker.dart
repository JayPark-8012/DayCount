import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';

class TodayMarker extends StatefulWidget {
  final bool isFirst;
  final bool isLast;

  const TodayMarker({
    super.key,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<TodayMarker> createState() => _TodayMarkerState();
}

class _TodayMarkerState extends State<TodayMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: AppConfig.todayGlowDuration,
    )..repeat(reverse: true);
    _glowAnim = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.sm),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: glow marker
            SizedBox(
              width: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top line
                  if (!widget.isFirst)
                    Container(
                      width: 2,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColor.withValues(alpha: 0.3),
                            AppColors.primaryColor.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  // Glow dot (28px, gradient)
                  AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (context, child) {
                      return Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor
                                  .withValues(alpha: (_glowAnim.value * 0.6).clamp(0.0, 1.0)),
                              blurRadius: 16,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Bottom line
                  if (!widget.isLast)
                    Container(
                      width: 2,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.secondaryColor.withValues(alpha: 0.5),
                            AppColors.secondaryColor.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppConfig.md),
            // Right: dashed line + TODAY label
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: _DashedLinePainter(
                        color:
                            AppColors.primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConfig.md,
                    ),
                    child: Text(
                      l10n.timeline_today,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: _DashedLinePainter(
                        color:
                            AppColors.primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashGap = 4.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(math.min(startX + dashWidth, size.width), y),
        paint,
      );
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
