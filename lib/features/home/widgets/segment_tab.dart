import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/glass_style.dart';
import '../../../l10n/app_localizations.dart';

class SegmentTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentTab({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      _TabData('\u{1F4CB}', l10n.home_tabList),
      _TabData('\u{1F4CA}', l10n.home_tabTimeline),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xxl),
      child: GlassContainer(
        borderRadius: AppConfig.segmentRadius,
        blur: 16,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: AppConfig.segmentAnimDuration,
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppConfig.segmentRadius - 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor
                            .withValues(alpha: isSelected ? 0.3 : 0.0),
                        blurRadius: isSelected ? 8 : 0,
                        offset: isSelected
                            ? const Offset(0, 2)
                            : Offset.zero,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tabs[index].emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tabs[index].label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabData {
  final String emoji;
  final String label;
  const _TabData(this.emoji, this.label);
}
