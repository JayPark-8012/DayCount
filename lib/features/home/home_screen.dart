import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/glass_style.dart';
import '../../core/widgets/press_scale.dart';
import '../../data/models/dday.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/celebration_providers.dart';
import '../../providers/dday_providers.dart';
import '../../providers/filter_providers.dart';
import '../../providers/settings_providers.dart';
import '../dday_detail/detail_screen.dart';
import '../dday_form/form_screen.dart';
import '../share_card/share_card_screen.dart';
import '../milestone_celebration/celebration_dialog.dart';
import '../settings/settings_screen.dart';
import '../timeline/timeline_view.dart';
import 'widgets/dday_card.dart';
import 'widgets/empty_state.dart';
import 'widgets/filter_chips.dart';
import 'widgets/hero_card.dart';
import 'widgets/list_header.dart';
import 'widgets/segment_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _celebrationChecked = false;
  late final PageController _pageController;
  int _currentPage = 0;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCelebrations();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkCelebrations() async {
    if (_celebrationChecked) return;
    _celebrationChecked = true;

    final celebrations = await ref.read(todayCelebrationsProvider.future);
    if (celebrations.isEmpty || !mounted) return;

    for (final item in celebrations) {
      if (!mounted) break;
      await _showCelebration(item);
      if (!mounted) break;
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShareCardScreen(dday: item.dday),
          ),
        );
      },
    );

    return completer.future;
  }

  Future<void> _markCelebrated(CelebrationItem item) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      await settingsRepo.set(
        'celebrated_${item.dday.id}_${item.milestone.id}',
        'true',
      );
    } catch (e) {
      debugPrint('[HomeScreen] Failed to mark celebrated: $e');
    }
  }

  void _onSegmentTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: AppConfig.segmentAnimDuration,
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastBackPressed != null &&
            now.difference(_lastBackPressed!) < const Duration(seconds: 2)) {
          Navigator.of(context).pop();
          return;
        }
        _lastBackPressed = now;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.home_pressBackToExit),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 80, left: 24, right: 24),
          ),
        );
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
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
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  // Settings button (GlassContainer 40x40)
                  GestureDetector(
                    onTap: () => _navigateToSettings(context),
                    child: GlassContainer(
                      borderRadius: 12,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '\u{2699}\u{FE0F}',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Segment tab ──
            Padding(
              padding: const EdgeInsets.only(
                top: AppConfig.xs,
                bottom: AppConfig.md,
              ),
              child: SegmentTab(
                selectedIndex: _currentPage,
                onChanged: _onSegmentTapped,
              ),
            ),

            // ── List / Timeline ──
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _ListPage(
                    onCreateTap: () => _navigateToCreate(context),
                    onDetailTap: (id) => _navigateToDetail(context, id),
                    onContextMenu: (dday) => _showContextMenu(context, dday),
                  ),
                  const TimelineView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return PressScale(
      scaleValue: 0.9,
      onTap: () => _navigateToCreate(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.45),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 30,
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
              final id = dday.id;
              if (id != null) {
                ref.read(ddayListProvider.notifier).deleteDday(id);
              }
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

/// List page shown as first page of PageView.
class _ListPage extends ConsumerWidget {
  final VoidCallback onCreateTap;
  final ValueChanged<int> onDetailTap;
  final ValueChanged<DDay> onContextMenu;

  const _ListPage({
    required this.onCreateTap,
    required this.onDetailTap,
    required this.onContextMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredDdayListProvider);
    final currentFilter = ref.watch(currentFilterProvider);

    return filteredAsync.when(
      data: (ddays) {
        if (ddays.isEmpty) {
          return HomeEmptyState(
            isFiltered: currentFilter != DdayFilter.all,
            onCreateTap: onCreateTap,
          );
        }
        final hero = _findHero(ddays);
        return CustomScrollView(
          slivers: [
            // Hero card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: HeroCard(
                  dday: hero,
                  onTap: () {
                    final id = hero.id;
                    if (id != null) onDetailTap(id);
                  },
                  onLongPress: () => onContextMenu(hero),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppConfig.md),
            ),

            // Filter chips
            const SliverToBoxAdapter(child: FilterChips()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppConfig.sm),
            ),

            // List header
            SliverToBoxAdapter(
              child: ListHeader(count: ddays.length),
            ),

            // Cards
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppSpacing.pageHorizontal,
                right: AppSpacing.pageHorizontal,
                top: AppConfig.sm,
                bottom: 100,
              ),
              sliver: SliverList.separated(
                itemCount: ddays.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.cardGap),
                itemBuilder: (context, index) {
                  final dday = ddays[index];
                  return DdayCard(
                    dday: dday,
                    index: index,
                    onTap: () {
                      final id = dday.id;
                      if (id != null) onDetailTap(id);
                    },
                    onLongPress: () => onContextMenu(dday),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
      error: (error, _) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: AppColors.errorColor),
        ),
      ),
    );
  }

  DDay _findHero(List<DDay> ddays) {
    final today = DateUtils.dateOnly(DateTime.now());
    for (final d in ddays) {
      final target = DateTime.parse(d.targetDate);
      if (!target.isBefore(today)) return d;
    }
    return ddays.first;
  }
}
