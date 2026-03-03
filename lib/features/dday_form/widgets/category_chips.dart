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
      _CategoryItem('anniversary', l10n.form_categoryAnniversary, '\u{1F389}'),
      _CategoryItem('couple', l10n.form_categoryCouple, '\u{1F495}'),
      _CategoryItem('exam', l10n.form_categoryExam, '\u{1F4DA}'),
      _CategoryItem('travel', l10n.form_categoryTravel, '\u{2708}'),
      _CategoryItem('birthday', l10n.form_categoryBirthday, '\u{1F382}'),
      _CategoryItem('baby', l10n.form_categoryBaby, '\u{1F476}'),
      _CategoryItem('custom', l10n.form_categoryCustom, '\u{26A1}'),
    ];

    return Wrap(
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
              // Active: tint background + primary border
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConfig.chipRadius),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              '${item.emoji} ${item.label}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryColor
                    : isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CategoryItem {
  final String id;
  final String label;
  final String emoji;

  const _CategoryItem(this.id, this.label, this.emoji);
}
