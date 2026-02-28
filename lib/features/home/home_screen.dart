import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../data/models/dday.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/celebration_providers.dart';
import '../../providers/dday_providers.dart';
import '../../providers/filter_providers.dart';
import '../../providers/settings_providers.dart';
import '../dday_detail/detail_screen.dart';
import '../dday_form/form_screen.dart';
import '../milestone_celebration/celebration_dialog.dart';
import '../settings/settings_screen.dart';
import 'widgets/dday_card.dart';
import 'widgets/empty_state.dart';
import 'widgets/filter_chips.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _celebrationChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCelebrations();
    });
  }

  Future<void> _checkCelebrations() async {
    if (_celebrationChecked) return;
    _celebrationChecked = true;

    final celebrations = await ref.read(todayCelebrationsProvider.future);
    if (celebrations.isEmpty || !mounted) return;

    for (final item in celebrations) {
      if (!mounted) break;
      await _showCelebration(item);
    }
  }

  Future<void> _showCelebration(CelebrationItem item) async {
    final completer = Completer<void>();

    showCelebrationDialog(
      context,
      dday: item.dday,
      milestone: item.milestone,
      onDismiss: () {
        Navigator.pop(context);
        _markCelebrated(item);
        completer.complete();
      },
      onShare: () {
        Navigator.pop(context);
        _markCelebrated(item);
        completer.complete();
        // TODO(T-share): Navigate to share card screen
      },
    );

    return completer.future;
  }

  Future<void> _markCelebrated(CelebrationItem item) async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.set(
      'celebrated_${item.dday.id}_${item.milestone.id}',
      'true',
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredDdayListProvider);
    final currentFilter = ref.watch(currentFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConfig.xl,
                vertical: AppConfig.sm,
              ),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.logoGradient,
                      borderRadius:
                          BorderRadius.circular(AppConfig.logoRadius),
                    ),
                    child: const Center(
                      child: Text(
                        'D',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConfig.sm),
                  Text(
                    l10n.home_title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  // View toggle
                  _AppBarIconButton(
                    icon: '\u{1F4CA}',
                    isDark: isDark,
                    onTap: () {
                      // TODO(T11): Navigate to timeline view
                    },
                  ),
                  const SizedBox(width: AppConfig.sm),
                  // Settings
                  _AppBarIconButton(
                    icon: '\u{2699}\u{FE0F}',
                    isDark: isDark,
                    onTap: () => _navigateToSettings(context),
                  ),
                ],
              ),
            ),

            // Filter chips
            const FilterChips(),
            const SizedBox(height: AppConfig.md),

            // Card list
            Expanded(
              child: filteredAsync.when(
                data: (ddays) {
                  if (ddays.isEmpty) {
                    return HomeEmptyState(
                      isFiltered: currentFilter != DdayFilter.all,
                      onCreateTap: () => _navigateToCreate(context),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      left: AppConfig.xl,
                      right: AppConfig.xl,
                      top: AppConfig.sm,
                      bottom: 100,
                    ),
                    itemCount: ddays.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppConfig.md),
                    itemBuilder: (context, index) {
                      final dday = ddays[index];
                      return DdayCard(
                        dday: dday,
                        index: index,
                        onTap: () => _navigateToDetail(context, dday.id!),
                        onLongPress: () => _showContextMenu(context, dday),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
                error: (error, _) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCreate(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig.fabRadius),
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, DDay dday) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConfig.sm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.dividerDark
                    : AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConfig.sm),
            ListTile(
              leading: const Text('\u{270F}\u{FE0F}',
                  style: TextStyle(fontSize: 20)),
              title: Text(l10n.home_edit),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DdayFormScreen(existingDday: dday),
                  ),
                );
              },
            ),
            ListTile(
              leading: Text(
                dday.isFavorite ? '\u{2B50}' : '\u{2606}',
                style: const TextStyle(fontSize: 20),
              ),
              title: Text(
                dday.isFavorite
                    ? l10n.home_unfavorite
                    : l10n.home_favorite,
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                ref
                    .read(ddayListProvider.notifier)
                    .toggleFavorite(dday);
              },
            ),
            ListTile(
              leading: const Text('\u{1F5D1}\u{FE0F}',
                  style: TextStyle(fontSize: 20)),
              title: Text(
                l10n.common_delete,
                style: const TextStyle(color: AppColors.errorColor),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _showDeleteConfirmDialog(context, dday);
              },
            ),
            const SizedBox(height: AppConfig.sm),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, DDay dday) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.home_deleteConfirmTitle),
        content: Text(l10n.home_deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(ddayListProvider.notifier).deleteDday(dday.id!);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DdayFormScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _navigateToDetail(BuildContext context, int ddayId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(ddayId: ddayId)),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final String icon;
  final bool isDark;
  final VoidCallback onTap;

  const _AppBarIconButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? AppColors.iconButtonDark : AppColors.iconButtonLight,
          borderRadius: BorderRadius.circular(AppConfig.iconButtonRadius),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
