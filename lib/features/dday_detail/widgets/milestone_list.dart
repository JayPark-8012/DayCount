import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/milestone_generator.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../data/models/milestone.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/milestone_providers.dart';

class MilestoneList extends ConsumerStatefulWidget {
  final int ddayId;
  final String targetDate;
  final String category;
  final List<Milestone> milestones;

  const MilestoneList({
    super.key,
    required this.ddayId,
    required this.targetDate,
    required this.category,
    required this.milestones,
  });

  @override
  ConsumerState<MilestoneList> createState() => _MilestoneListState();
}

class _MilestoneListState extends ConsumerState<MilestoneList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  static const int _collapsedCount = 3;
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(MilestoneList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.milestones.length != widget.milestones.length) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime _milestoneDate(Milestone milestone) {
    final target = DateTime.parse(widget.targetDate);
    return target.subtract(Duration(days: milestone.days));
  }

  int _daysFromToday(Milestone milestone) {
    final today = DateUtils.dateOnly(DateTime.now());
    final mDate = DateUtils.dateOnly(_milestoneDate(milestone));
    return mDate.difference(today).inDays;
  }

  bool _isMilestoneReached(Milestone milestone) {
    return _daysFromToday(milestone) <= 0;
  }

  void _showAddCustomDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(
          l10n.detail_customTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.detail_customHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () async {
              final days = int.tryParse(controller.text);
              if (days == null || days <= 0) return;

              final milestone = Milestone(
                ddayId: widget.ddayId,
                days: days,
                label: 'D-$days',
                isCustom: true,
              );

              try {
                final repo = ref.read(milestoneRepositoryProvider);
                await repo.insert(milestone);
                ref.invalidate(milestonesForDdayProvider(widget.ddayId));

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(dialogContext)!.error_saveFailed,
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort milestones descending by days (D-100 first, D-Day last)
    final sorted = List<Milestone>.from(widget.milestones)
      ..sort((a, b) => b.days.compareTo(a.days));

    final showToggle = sorted.length > _collapsedCount;
    final visible =
        _isExpanded ? sorted : sorted.take(_collapsedCount).toList();

    return FadeTransition(
      opacity: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — "마일스톤" 17pt w800 + "+ 커스텀"
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
            ),
            child: Row(
              children: [
                Text(
                  l10n.detail_milestones,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const Spacer(),
                PressScale(
                  onTap: _showAddCustomDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConfig.sm,
                      vertical: AppConfig.md,
                    ),
                    child: Text(
                      l10n.detail_addCustom,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConfig.lg),

          if (sorted.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: AppConfig.lg,
              ),
              child: Center(
                child: Text(
                  l10n.detail_noMilestones,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            )
          else ...[
            // Timeline milestone rows
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                children: List.generate(visible.length, (index) {
                  final milestone = visible[index];
                  final reached = _isMilestoneReached(milestone);
                  final daysFromToday = _daysFromToday(milestone);
                  final mDate = _milestoneDate(milestone);
                  return _TimelineMilestoneRow(
                    milestone: milestone,
                    reached: reached,
                    daysFromToday: daysFromToday,
                    milestoneDate: _dateFormat.format(mDate),
                    isDark: isDark,
                    isFirst: index == 0,
                    isLast: index == visible.length - 1,
                  );
                }),
              ),
            ),

            // Toggle button — "모두 보기 (8개)"
            if (showToggle)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: PressScale(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppConfig.md),
                    child: Text(
                      _isExpanded
                          ? l10n.detail_collapse
                          : l10n.detail_showAll(sorted.length),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// A single milestone row with timeline node on the left.
class _TimelineMilestoneRow extends StatelessWidget {
  final Milestone milestone;
  final bool reached;
  final int daysFromToday;
  final String milestoneDate;
  final bool isDark;
  final bool isFirst;
  final bool isLast;

  const _TimelineMilestoneRow({
    required this.milestone,
    required this.reached,
    required this.daysFromToday,
    required this.milestoneDate,
    required this.isDark,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final absDays = daysFromToday.abs();

    // Status text
    final String statusText;
    if (daysFromToday == 0) {
      statusText = l10n.detail_milestoneToday;
    } else if (reached) {
      statusText = l10n.detail_milestoneDaysAgo(absDays);
    } else {
      statusText = l10n.detail_daysRemaining(absDays);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: Opacity(
        opacity: reached ? 0.45 : 1.0,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Timeline column — node + lines
              SizedBox(
                width: AppConfig.detailMilestoneNodeSize,
                child: Column(
                  children: [
                    // Top line
                    Expanded(
                      child: isFirst
                          ? const SizedBox.shrink()
                          : Container(
                              width: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryColor
                                        .withValues(alpha: 0.15),
                                    AppColors.primaryColor
                                        .withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    // Node — 32px
                    _MilestoneNode(reached: reached, isDark: isDark),
                    // Bottom line
                    Expanded(
                      child: isLast
                          ? const SizedBox.shrink()
                          : Container(
                              width: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryColor
                                        .withValues(alpha: 0.3),
                                    AppColors.primaryColor
                                        .withValues(alpha: 0.15),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConfig.md),

              // Content — 3 columns: [label] [date] [status]
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppConfig.md),
                  child: Row(
                    children: [
                      // Label (D-100, D-Day)
                      SizedBox(
                        width: 56,
                        child: Text(
                          localizedMilestoneLabel(milestone.days),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConfig.sm),

                      // Date
                      Expanded(
                        child: Text(
                          milestoneDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),

                      // Status
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: reached
                              ? (isDark
                                  ? AppColors.successColorDark
                                  : AppColors.successColor)
                              : AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 32px milestone node.
/// Reached: green gradient + checkmark + glow shadow.
/// Unreached: glass background with border.
class _MilestoneNode extends StatelessWidget {
  final bool reached;
  final bool isDark;

  const _MilestoneNode({required this.reached, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const size = AppConfig.detailMilestoneNodeSize;

    if (reached) {
      // Green gradient node + check + shadow
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? AppColors.successColorDark : AppColors.successColor,
              isDark
                  ? AppColors.successColorDark.withValues(alpha: 0.7)
                  : AppColors.successColor.withValues(alpha: 0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark
                      ? AppColors.successColorDark
                      : AppColors.successColor)
                  .withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.check, size: 16, color: Colors.white),
        ),
      );
    }

    // Glass-style unreached node
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? const Color(0x331A1A30)
                : const Color(0x33FFFFFF),
            border: Border.all(
              color: isDark
                  ? AppColors.textDisabledDark.withValues(alpha: 0.4)
                  : AppColors.textDisabledLight.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
