import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';

/// Toggle between [Color] and [Photo] background modes.
class BackgroundSelector extends StatelessWidget {
  final bool isPhotoMode;
  final VoidCallback onColorTap;
  final VoidCallback onPhotoTap;

  const BackgroundSelector({
    super.key,
    required this.isPhotoMode,
    required this.onColorTap,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.share_background,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppConfig.sm),
          Row(
            children: [
              _ToggleChip(
                label: l10n.share_bgColor,
                selected: !isPhotoMode,
                onTap: onColorTap,
                isDark: isDark,
              ),
              const SizedBox(width: AppConfig.sm),
              _ToggleChip(
                label: '\u{1F4F8} ${l10n.share_bgPhoto}',
                selected: isPhotoMode,
                onTap: onPhotoTap,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.textDisabledDark
                      : AppColors.textDisabledLight,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
