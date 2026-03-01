import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/utils/milestone_generator.dart';
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
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds:
            400 + (widget.milestones.length * 80).clamp(0, 800),
      ),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(MilestoneList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.milestones.length != widget.milestones.length) {
      _controller.duration = Duration(
        milliseconds:
            400 + (widget.milestones.length * 80).clamp(0, 800),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isMilestoneReached(Milestone milestone) {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateTime.parse(widget.targetDate);

    if (widget.category == 'exam') {
      final daysLeft = target.difference(today).inDays;
      return daysLeft <= milestone.days;
    }

    final daysSince = today.difference(target).inDays;
    return daysSince >= milestone.days;
  }

  int _daysUntilMilestone(Milestone milestone) {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateTime.parse(widget.targetDate);

    if (widget.category == 'exam') {
      final milestoneDate = target.subtract(Duration(days: milestone.days));
      return milestoneDate.difference(today).inDays;
    }

    final milestoneDate = target.add(Duration(days: milestone.days));
    return milestoneDate.difference(today).inDays;
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
                label: l10n.detail_customLabel(days),
                isCustom: true,
              );

              final repo = ref.read(milestoneRepositoryProvider);
              await repo.insert(milestone);
              ref.invalidate(milestonesForDdayProvider(widget.ddayId));

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );
  }

  bool _isTargetInFuture() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateTime.parse(widget.targetDate);
    return target.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hideMilestones =
        widget.category != 'exam' && _isTargetInFuture();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
          child: Row(
            children: [
              Text(
                l10n.detail_milestones,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              if (!hideMilestones)
                GestureDetector(
                  onTap: _showAddCustomDialog,
                  child: Text(
                    l10n.detail_addCustom,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppConfig.md),

        if (hideMilestones)
          // Show placeholder for future non-exam D-Days
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConfig.xl,
              vertical: AppConfig.lg,
            ),
            child: Center(
              child: Text(
                l10n.detail_milestonesAfterDday,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
          )
        else
          // Milestone items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
            itemCount: widget.milestones.length,
            itemBuilder: (context, index) {
              final milestone = widget.milestones[index];
              final reached = _isMilestoneReached(milestone);
              final daysLeft = _daysUntilMilestone(milestone);

              final double begin = (index * 80 /
                      (_controller.duration?.inMilliseconds ?? 1))
                  .clamp(0.0, 0.7);
              final double end = (begin + 0.3).clamp(0.0, 1.0);

              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(begin, end, curve: Curves.easeOut),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(animation),
                  child: _MilestoneRow(
                    milestone: milestone,
                    reached: reached,
                    daysLeft: daysLeft,
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final Milestone milestone;
  final bool reached;
  final int daysLeft;
  final bool isDark;

  const _MilestoneRow({
    required this.milestone,
    required this.reached,
    required this.daysLeft,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.md),
      child: Opacity(
        opacity: reached ? 0.6 : 1.0,
        child: Row(
          children: [
            // Check / Circle icon
            Container(
              width: 28,
              height: 28,
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
                        width: 2,
                      ),
              ),
              child: reached
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppConfig.md),

            // Label
            Expanded(
              child: Text(
                localizedMilestoneLabel(l10n, milestone.days),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),

            // Status
            Text(
              reached
                  ? l10n.detail_reached
                  : l10n.detail_daysRemaining(daysLeft.abs()),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: reached
                    ? (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)
                    : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
