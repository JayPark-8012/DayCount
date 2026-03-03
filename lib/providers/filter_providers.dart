import 'package:flutter/material.dart' show DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dday.dart';
import 'dday_providers.dart';
import 'settings_providers.dart';

// --- Filter ---
enum DdayFilter { all, anniversary, couple, exam, travel, birthday, baby, custom, favorites }

final currentFilterProvider = StateProvider<DdayFilter>((ref) {
  return DdayFilter.all;
});

// --- Sort ---
enum DdaySort { dateAsc, dateDesc, created }

DdaySort _parseSortString(String value) {
  return switch (value) {
    'date_desc' => DdaySort.dateDesc,
    'created' => DdaySort.created,
    _ => DdaySort.dateAsc,
  };
}

final currentSortProvider = StateProvider<DdaySort>((ref) {
  final defaultSort = ref.watch(defaultSortProvider).valueOrNull ?? 'date_asc';
  return _parseSortString(defaultSort);
});

// --- Filtered + Sorted list ---
final filteredDdayListProvider = Provider<AsyncValue<List<DDay>>>((ref) {
  final listAsync = ref.watch(ddayListProvider);
  final filter = ref.watch(currentFilterProvider);
  final sort = ref.watch(currentSortProvider);

  return listAsync.whenData((list) {
    // Filter — always create a new list to avoid mutating provider state
    final filtered = switch (filter) {
      DdayFilter.all => List<DDay>.of(list),
      DdayFilter.anniversary => list.where((d) => d.category == 'anniversary' || d.category == 'general').toList(),
      DdayFilter.couple => list.where((d) => d.category == 'couple').toList(),
      DdayFilter.exam => list.where((d) => d.category == 'exam').toList(),
      DdayFilter.travel => list.where((d) => d.category == 'travel').toList(),
      DdayFilter.birthday => list.where((d) => d.category == 'birthday').toList(),
      DdayFilter.baby => list.where((d) => d.category == 'baby').toList(),
      DdayFilter.custom => list.where((d) => d.category == 'custom').toList(),
      DdayFilter.favorites => list.where((d) => d.isFavorite).toList(),
    };

    // Sort
    switch (sort) {
      case DdaySort.dateAsc:
        // Future-first: nearest future → far future → recent past → far past
        final today = DateUtils.dateOnly(DateTime.now());
        filtered.sort((a, b) {
          final daysA = DateTime.parse(a.targetDate).difference(today).inDays;
          final daysB = DateTime.parse(b.targetDate).difference(today).inDays;
          if (daysA >= 0 && daysB >= 0) return daysA.compareTo(daysB);
          if (daysA < 0 && daysB < 0) return daysB.compareTo(daysA);
          if (daysA >= 0) return -1;
          return 1;
        });
      case DdaySort.dateDesc:
        filtered.sort((a, b) => b.targetDate.compareTo(a.targetDate));
      case DdaySort.created:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  });
});
