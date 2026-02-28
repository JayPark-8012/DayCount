import 'package:flutter/material.dart' show DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dday.dart';
import '../data/models/milestone.dart';
import 'dday_providers.dart';
import 'milestone_providers.dart';
import 'settings_providers.dart';

class CelebrationItem {
  final DDay dday;
  final Milestone milestone;

  const CelebrationItem({required this.dday, required this.milestone});
}

final todayCelebrationsProvider =
    FutureProvider<List<CelebrationItem>>((ref) async {
  final ddayListAsync = ref.watch(ddayListProvider);
  final ddays = ddayListAsync.valueOrNull;
  if (ddays == null || ddays.isEmpty) return [];

  final milestoneRepo = ref.read(milestoneRepositoryProvider);
  final settingsRepo = ref.read(settingsRepositoryProvider);
  final today = DateUtils.dateOnly(DateTime.now());

  final celebrations = <CelebrationItem>[];

  for (final dday in ddays) {
    if (dday.id == null) continue;
    final milestones = await milestoneRepo.getByDdayId(dday.id!);
    final target = DateTime.parse(dday.targetDate);

    for (final milestone in milestones) {
      if (milestone.id == null) continue;

      final mDate = _milestoneDate(target, milestone.days, dday.category);
      final mDateOnly = DateUtils.dateOnly(mDate);

      if (mDateOnly == today) {
        final settingsKey = 'celebrated_${dday.id}_${milestone.id}';
        final alreadyShown = await settingsRepo.getBool(settingsKey);
        if (!alreadyShown) {
          celebrations
              .add(CelebrationItem(dday: dday, milestone: milestone));
        }
      }
    }
  }

  return celebrations;
});

DateTime _milestoneDate(DateTime target, int days, String category) {
  if (category == 'exam') {
    return target.subtract(Duration(days: days));
  }
  return target.add(Duration(days: days));
}
