import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/filter_providers.dart';

class ListHeader extends ConsumerWidget {
  final int count;

  const ListHeader({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentSort = ref.watch(currentSortProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.xxl,
        vertical: AppConfig.sm,
      ),
      child: Row(
        children: [
          Text(
            l10n.home_ddayCount(count),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              final next = switch (currentSort) {
                DdaySort.dateAsc => DdaySort.dateDesc,
                DdaySort.dateDesc => DdaySort.created,
                DdaySort.created => DdaySort.dateAsc,
              };
              ref.read(currentSortProvider.notifier).state = next;
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _sortLabel(l10n, currentSort),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.swap_vert,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sortLabel(AppLocalizations l10n, DdaySort sort) {
    return switch (sort) {
      DdaySort.dateAsc => l10n.sort_nearest,
      DdaySort.dateDesc => l10n.sort_farthest,
      DdaySort.created => l10n.sort_recent,
    };
  }
}
