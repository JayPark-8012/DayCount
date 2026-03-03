import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  final bool isFavorite;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteIcon({
    super.key,
    required this.isFavorite,
    this.size = 22,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: isFavorite
          ? (activeColor ?? Colors.amber.shade500)
          : (inactiveColor ?? Colors.grey.shade400),
    );
  }
}
