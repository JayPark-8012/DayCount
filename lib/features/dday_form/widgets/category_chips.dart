import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = <_CategoryItem>[
      _CategoryItem('general', l10n.form_categoryGeneral, '\u{1F4C5}'),
      _CategoryItem('couple', l10n.form_categoryCouple, '\u{1F495}'),
      _CategoryItem('exam', l10n.form_categoryExam, '\u{1F4DA}'),
      _CategoryItem('baby', l10n.form_categoryBaby, '\u{1F476}'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.form_categoryLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppConfig.sm),
        Wrap(
          spacing: AppConfig.sm,
          runSpacing: AppConfig.sm,
          children: categories.map((item) {
            final isSelected = item.id == selectedCategory;
            return GestureDetector(
              onTap: () => onCategoryChanged(item.id),
              child: AnimatedContainer(
                duration: AppConfig.chipAnimDuration,
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppConfig.chipRadius),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight,
                        ),
                ),
                child: Text(
                  '${item.emoji} ${item.label}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryItem {
  final String id;
  final String label;
  final String emoji;

  const _CategoryItem(this.id, this.label, this.emoji);
}
