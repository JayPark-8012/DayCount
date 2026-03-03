import 'package:flutter/material.dart';

/// Wraps [child] with a press-to-shrink scale animation.
///
/// On tap-down the widget scales to [scaleValue] (default 0.97),
/// then springs back on release. Duration 150ms, curve easeOutBack.
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.97,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleValue : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
