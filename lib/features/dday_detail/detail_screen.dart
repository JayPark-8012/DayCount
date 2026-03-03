import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/card_themes.dart';
import '../../core/theme/glass_style.dart';
import '../../core/widgets/card_pattern.dart';
import '../../core/widgets/favorite_icon.dart';
import '../../core/widgets/press_scale.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/dday_providers.dart';
import '../../providers/milestone_providers.dart';
import '../dday_form/form_screen.dart';
import '../share_card/share_card_screen.dart';
import 'widgets/counter_display.dart';
import 'widgets/milestone_list.dart';
import 'widgets/sub_counts.dart';

class DetailScreen extends ConsumerWidget {
  final int ddayId;

  const DetailScreen({super.key, required this.ddayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ddayAsync = ref.watch(ddayDetailProvider(ddayId));
    final milestonesAsync = ref.watch(milestonesForDdayProvider(ddayId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ddayAsync.when(
      loading: () => Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: AppColors.errorColor),
          ),
        ),
      ),
      data: (dday) {
        if (dday == null) {
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            body: Center(child: Text(l10n.detail_notFound)),
          );
        }

        final theme = getCardTheme(dday.themeId);
        final today = DateUtils.dateOnly(DateTime.now());
        final target = DateTime.parse(dday.targetDate);
        final daysDiff = target.difference(today).inDays;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Theme header area ──
                // Bottom radius 36, accent line, shadow
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: theme.background,
                    borderRadius: BorderRadius.vertical(
                      bottom:
                          Radius.circular(AppConfig.detailHeaderRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? const Color(0x66000000)
                            : const Color(0x0F000000),
                        blurRadius: isDark ? 40 : 32,
                        offset: isDark
                            ? const Offset(0, 12)
                            : const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Theme pattern
                      CardPattern(
                        type: theme.pattern,
                        color: theme.accentColor,
                        opacity: 0.18,
                      ),
                      SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Top accent line — 3px gradient fade
                        Container(
                          width: double.infinity,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.accentColor.withValues(alpha: 0.0),
                                theme.accentColor.withValues(alpha: 0.6),
                                theme.accentColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),

                        // App bar — glass back / glass edit
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConfig.sm,
                            vertical: AppConfig.xs,
                          ),
                          child: Row(
                            children: [
                              // ← Back — glass 40x40, radius 12, blur 10
                              PressScale(
                                onTap: () => Navigator.pop(context),
                                child: GlassContainer(
                                  borderRadius: 12,
                                  blur: 10,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: theme.textColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // ⭐ Favorite toggle
                              PressScale(
                                onTap: () {
                                  ref.read(ddayListProvider.notifier).toggleFavorite(dday);
                                  HapticFeedback.selectionClick();
                                },
                                child: GlassContainer(
                                  borderRadius: 12,
                                  blur: 10,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: FavoriteIcon(
                                        isFavorite: dday.isFavorite,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConfig.sm),
                              // ✏️ Edit — glass 40x40, radius 12, blur 10
                              PressScale(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DdayFormScreen(existingDday: dday),
                                    ),
                                  );
                                  if (context.mounted) {
                                    ref.invalidate(ddayListProvider);
                                  }
                                },
                                child: GlassContainer(
                                  borderRadius: 12,
                                  blur: 10,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        '\u270F\uFE0F',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: theme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Emoji + Title + Day count
                        CounterDisplay(
                          emoji: dday.emoji,
                          title: dday.title,
                          daysDiff: daysDiff,
                          isCountUp: dday.isCountUp,
                          theme: theme,
                        ),

                        // Sub counts — glass chips
                        SubCounts(totalDays: daysDiff, theme: theme),
                        const SizedBox(height: AppConfig.xxl),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),

                // ── Bottom section ──
                const SizedBox(height: AppSpacing.sectionGap),

                // Milestones
                milestonesAsync.when(
                  data: (milestones) => MilestoneList(
                    ddayId: ddayId,
                    targetDate: dday.targetDate,
                    category: dday.category,
                    milestones: milestones,
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppConfig.xxl),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(AppConfig.xxl),
                    child: Text(e.toString()),
                  ),
                ),

                const SizedBox(height: AppSpacing.sectionGap),

                // Share Card button — gradient + radius 18 + shadow + PressScale
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                  ),
                  child: PressScale(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShareCardScreen(dday: dday),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(
                          AppConfig.detailShareRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '\u{1F4E4}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: AppConfig.sm),
                          Text(
                            l10n.detail_shareCard,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sectionGap),

                // Created date — bottom center, 11pt, textSecondary, letterSpacing 0.3
                Text(
                  l10n.detail_createdAt(dday.createdAt.split('T').first),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }
}
