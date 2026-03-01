import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

/// Category-specific section for the detail screen.
/// Shows exam countdown or baby growth info (free for all users).
class CategorySection extends StatelessWidget {
  final DDay dday;

  const CategorySection({super.key, required this.dday});

  @override
  Widget build(BuildContext context) {
    return switch (dday.category) {
      'exam' => _ExamSection(dday: dday),
      'baby' => _BabySection(dday: dday),
      _ => const SizedBox.shrink(),
    };
  }
}

// ─────────────────────────────────────────────
// Exam Section — weeks/days emphasis
// ─────────────────────────────────────────────

class _ExamSection extends StatelessWidget {
  final DDay dday;
  const _ExamSection({required this.dday});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateTime.parse(dday.targetDate);
    final daysLeft = target.difference(today).inDays;

    final isCompleted = daysLeft <= 0;
    final weeks = daysLeft ~/ 7;
    final remainingDays = daysLeft % 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.detail_examTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppConfig.md),

          if (isCompleted)
            // Exam completed
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppConfig.xl),
              decoration: BoxDecoration(
                color: (isDark
                        ? AppColors.successColorDark
                        : AppColors.successColor)
                    .withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppConfig.milestoneCardRadius),
              ),
              child: Center(
                child: Text(
                  l10n.detail_examCompleted,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.successColorDark
                        : AppColors.successColor,
                  ),
                ),
              ),
            )
          else ...[
            // Remaining label
            Center(
              child: Text(
                l10n.detail_examRemaining(weeks, remainingDays),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
            const SizedBox(height: AppConfig.md),

            // Week/Day cards
            Row(
              children: [
                _ExamCountCard(
                  value: '$weeks',
                  label: l10n.detail_weeks,
                  isDark: isDark,
                ),
                const SizedBox(width: AppConfig.sm),
                _ExamCountCard(
                  value: '$remainingDays',
                  label: l10n.detail_days,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExamCountCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _ExamCountCard({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConfig.lg),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(AppConfig.milestoneCardRadius),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Baby Section — month age + growth milestones
// ─────────────────────────────────────────────

class _BabySection extends StatelessWidget {
  final DDay dday;
  const _BabySection({required this.dday});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateUtils.dateOnly(DateTime.now());
    final birth = DateTime.parse(dday.targetDate);

    // Calendar-based month calculation (date-rules.md)
    int monthsSince =
        (today.year - birth.year) * 12 + (today.month - birth.month);
    if (today.day < birth.day) monthsSince--;
    if (monthsSince < 0) monthsSince = 0;

    // Remaining days within current month
    int remainingDays;
    if (today.day >= birth.day) {
      remainingDays = today.day - birth.day;
    } else {
      final prevMonthDate =
          DateTime(today.year, today.month - 1, birth.day);
      remainingDays = today.difference(prevMonthDate).inDays;
    }
    if (remainingDays < 0) remainingDays = 0;

    // Growth milestones
    final growthMilestones = [
      _GrowthMilestone(
        name: l10n.detail_babyRolling,
        ageLabel: l10n.detail_babyRollingAge,
        reachedMonth: 3,
      ),
      _GrowthMilestone(
        name: l10n.detail_babySitting,
        ageLabel: l10n.detail_babySittingAge,
        reachedMonth: 6,
      ),
      _GrowthMilestone(
        name: l10n.detail_babyCrawling,
        ageLabel: l10n.detail_babyCrawlingAge,
        reachedMonth: 8,
      ),
      _GrowthMilestone(
        name: l10n.detail_babyWalking,
        ageLabel: l10n.detail_babyWalkingAge,
        reachedMonth: 12,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.detail_babyTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppConfig.md),

          // Age display
          Center(
            child: Text(
              l10n.detail_babyAge(monthsSince, remainingDays),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: AppConfig.xl),

          // Growth milestones
          ...growthMilestones.map((milestone) {
            final reached = monthsSince >= milestone.reachedMonth;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConfig.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConfig.lg,
                  vertical: AppConfig.md,
                ),
                decoration: BoxDecoration(
                  color: reached
                      ? (isDark
                              ? AppColors.successColorDark
                              : AppColors.successColor)
                          .withValues(alpha: 0.08)
                      : isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                  borderRadius:
                      BorderRadius.circular(AppConfig.milestoneCardRadius),
                ),
                child: Row(
                  children: [
                    // Check / Circle
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reached
                            ? (isDark
                                ? AppColors.successColorDark
                                : AppColors.successColor)
                            : Colors.transparent,
                        border: reached
                            ? null
                            : Border.all(
                                color: isDark
                                    ? AppColors.textDisabledDark
                                    : AppColors.textDisabledLight,
                                width: 1.5,
                              ),
                      ),
                      child: reached
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: AppConfig.md),

                    // Name
                    Expanded(
                      child: Text(
                        milestone.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),

                    // Age label
                    Text(
                      milestone.ageLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GrowthMilestone {
  final String name;
  final String ageLabel;
  final int reachedMonth;

  const _GrowthMilestone({
    required this.name,
    required this.ageLabel,
    required this.reachedMonth,
  });
}
