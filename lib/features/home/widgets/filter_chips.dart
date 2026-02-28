import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/filter_providers.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentFilterProvider);
    final l10n = AppLocalizations.of(context)!;

    final items = <_FilterItem>[
      _FilterItem(DdayFilter.all, l10n.home_filterAll, null),
      _FilterItem(DdayFilter.couple, l10n.home_filterCouple, '\u{1F495}'),
      _FilterItem(DdayFilter.exam, l10n.home_filterExam, '\u{1F4DA}'),
      _FilterItem(DdayFilter.baby, l10n.home_filterBaby, '\u{1F476}'),
      _FilterItem(DdayFilter.favorites, l10n.home_filterFavorites, '\u{2B50}'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppConfig.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.filter == current;
          return _Chip(
            label: item.emoji != null ? '${item.emoji} ${item.label}' : item.label,
            isSelected: isSelected,
            onTap: () {
              ref.read(currentFilterProvider.notifier).state = item.filter;
            },
          );
        },
      ),
    );
  }
}

class _FilterItem {
  final DdayFilter filter;
  final String label;
  final String? emoji;

  const _FilterItem(this.filter, this.label, this.emoji);
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConfig.chipAnimDuration,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppConfig.chipRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
