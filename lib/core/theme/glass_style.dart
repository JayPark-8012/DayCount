import 'dart:ui';

import 'package:flutter/material.dart';

/// Glassmorphism container with backdrop blur and translucent background.
///
/// Light: background rgba(255,255,255,0.55), blur 12, border rgba(255,255,255,0.7)
/// Dark:  background rgba(26,26,48,0.6),     blur 12, border rgba(255,255,255,0.08)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 18,
    this.padding,
    this.blur = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0x991A1A30) // rgba(26,26,48,0.6)
                : const Color(0x8CFFFFFF), // rgba(255,255,255,0.55)
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? const Color(0x14FFFFFF) // rgba(255,255,255,0.08)
                  : const Color(0xB3FFFFFF), // rgba(255,255,255,0.7)
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
