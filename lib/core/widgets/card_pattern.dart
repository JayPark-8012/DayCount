import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/card_theme.dart';

/// Renders a decorative pattern overlay for card themes.
///
/// Place inside a [Stack] with [Positioned.fill] over the card background.
/// The [opacity] controls pattern visibility (typically 0.06–0.12).
class CardPattern extends StatelessWidget {
  final CardPatternType type;
  final Color color;
  final double opacity;

  const CardPattern({
    super.key,
    required this.type,
    required this.color,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _PatternPainter(
          type: type,
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final CardPatternType type;
  final Color color;
  final double opacity;

  const _PatternPainter({
    required this.type,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    switch (type) {
      case CardPatternType.circles:
        _paintCircles(canvas, size);
      case CardPatternType.waves:
        _paintWaves(canvas, size);
      case CardPatternType.leaves:
        _paintLeaves(canvas, size);
      case CardPatternType.stars:
        _paintStars(canvas, size);
      case CardPatternType.petals:
        _paintPetals(canvas, size);
      case CardPatternType.aurora:
        _paintAurora(canvas, size);
    }
  }

  // ── circles: 큰 원(r90) + 작은 원(r50), 우상단 (안쪽으로) ──
  void _paintCircles(Canvas canvas, Size size) {
    final cx = size.width - 20;
    final cy = -10.0;

    // Big circle
    canvas.drawCircle(
      Offset(cx, cy),
      90,
      Paint()..color = color.withValues(alpha: opacity),
    );

    // Small circle
    canvas.drawCircle(
      Offset(cx - 60, cy + 70),
      50,
      Paint()..color = color.withValues(alpha: opacity * 0.5),
    );
  }

  // ── waves: 2겹 QuadraticBezier, 40%부터 시작 ──
  void _paintWaves(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: opacity);

    // Wave 1 — starts at 20%
    final path1 = Path()
      ..moveTo(w * 0.2, h)
      ..quadraticBezierTo(w * 0.4, h * 0.65, w * 0.65, h * 0.78)
      ..quadraticBezierTo(w * 0.85, h * 0.88, w, h * 0.7)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(path1, paint);

    // Wave 2 (lighter) — starts at 35%
    final path2 = Path()
      ..moveTo(w * 0.35, h)
      ..quadraticBezierTo(w * 0.55, h * 0.75, w * 0.75, h * 0.85)
      ..quadraticBezierTo(w * 0.9, h * 0.92, w, h * 0.78)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      path2,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: opacity * 0.5),
    );
  }

  // ── leaves: 회전 타원 3개(30°, -20°, 45°), 우상단, 1.5x 스케일 ──
  void _paintLeaves(Canvas canvas, Size size) {
    final cx = size.width - 40;
    const cy = 15.0;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: opacity);

    const angles = [30.0, -20.0, 45.0];
    const scales = [1.0, 0.7, 0.5];
    const offsets = [
      Offset(0, 0),
      Offset(-50, 20),
      Offset(-20, 55),
    ];

    for (var i = 0; i < angles.length; i++) {
      canvas.save();
      canvas.translate(cx + offsets[i].dx, cy + offsets[i].dy);
      canvas.rotate(angles[i] * math.pi / 180);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: 90 * scales[i],
          height: 36 * scales[i],
        ),
        paint,
      );
      canvas.restore();
    }
  }

  // ── stars: 크기 다른 원 12개, 카드 전체에 퍼짐, opacity 2.5배 ──
  void _paintStars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(
        alpha: (opacity * 2.5).clamp(0.0, 1.0),
      );

    final w = size.width;
    final h = size.height;
    // Spread across the whole card
    const stars = [
      _Star(0.85, 0.10, 4.0),
      _Star(0.92, 0.06, 2.5),
      _Star(0.72, 0.22, 3.0),
      _Star(0.95, 0.25, 2.2),
      _Star(0.88, 0.40, 3.5),
      _Star(0.65, 0.08, 2.5),
      _Star(0.98, 0.18, 3.5),
      _Star(0.75, 0.45, 2.8),
      _Star(0.15, 0.15, 2.0),
      _Star(0.30, 0.80, 2.5),
      _Star(0.50, 0.55, 2.2),
      _Star(0.10, 0.60, 1.8),
    ];

    for (final s in stars) {
      canvas.drawCircle(
        Offset(w * s.rx, h * s.ry),
        s.radius,
        paint,
      );
    }
  }

  // ── petals: 꽃잎 6장(60° 간격 회전 타원), 우상단, 더 크게 ──
  void _paintPetals(Canvas canvas, Size size) {
    final cx = size.width - 30;
    const cy = 20.0;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: opacity);

    for (var i = 0; i < 6; i++) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(i * math.pi / 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: const Offset(0, -35),
          width: 26,
          height: 56,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  // ── aurora: 물결 그라데이션 2겹, 50%부터 시작 ──
  void _paintAurora(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Layer 1 — starts at 50%
    final path1 = Path()
      ..moveTo(0, h * 0.5)
      ..cubicTo(w * 0.25, h * 0.4, w * 0.5, h * 0.65, w, h * 0.45)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      path1,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: opacity),
    );

    // Layer 2 (lighter, shifted) — starts at 65%
    final path2 = Path()
      ..moveTo(0, h * 0.65)
      ..cubicTo(w * 0.3, h * 0.55, w * 0.65, h * 0.75, w, h * 0.6)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      path2,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: opacity * 0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return type != oldDelegate.type ||
        color != oldDelegate.color ||
        opacity != oldDelegate.opacity;
  }
}

class _Star {
  final double rx;
  final double ry;
  final double radius;

  const _Star(this.rx, this.ry, this.radius);
}
