import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/card_themes.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/dday_providers.dart';
import '../../providers/milestone_providers.dart';
import '../dday_form/form_screen.dart';
import '../share_card/share_card_screen.dart';
import 'widgets/category_section.dart';
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Top gradient section ──
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(gradient: theme.background),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // App bar row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConfig.sm,
                            vertical: AppConfig.xs,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: theme.textColor,
                                  size: 22,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DdayFormScreen(existingDday: dday),
                                    ),
                                  );
                                  ref.invalidate(ddayListProvider);
                                },
                                icon: Text(
                                  '\u270F\uFE0F',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: theme.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Counter display
                        CounterDisplay(
                          emoji: dday.emoji,
                          title: dday.title,
                          daysDiff: daysDiff,
                          isCountUp: dday.isCountUp,
                          theme: theme,
                        ),

                        // Sub counts
                        SubCounts(totalDays: daysDiff, theme: theme),
                        const SizedBox(height: AppConfig.xxl),
                      ],
                    ),
                  ),
                ),

                // ── Bottom section (app background) ──
                Container(
                  width: double.infinity,
                  transform: Matrix4.translationValues(0, -28, 0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppConfig.xxl),

                      // Category-specific PRO section
                      if (dday.category != 'general') ...[
                        CategorySection(dday: dday),
                        const SizedBox(height: AppConfig.lg),
                      ],

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

                      const SizedBox(height: AppConfig.xxl),

                      // Share Card button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConfig.xl,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ShareCardScreen(dday: dday),
                                ),
                              );
                            },
                            icon: const Text(
                              '\u{1F4E4}',
                              style: TextStyle(fontSize: 16),
                            ),
                            label: Text(l10n.detail_shareCard),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
