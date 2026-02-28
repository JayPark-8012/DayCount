import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dday.dart';
import 'dday_providers.dart';

// --- Filter ---
enum DdayFilter { all, couple, exam, baby, favorites }

final currentFilterProvider = StateProvider<DdayFilter>((ref) {
  return DdayFilter.all;
});

// --- Sort ---
enum DdaySort { dateAsc, dateDesc, created, manual }

final currentSortProvider = StateProvider<DdaySort>((ref) {
  return DdaySort.dateAsc;
});

// --- Filtered + Sorted list ---
final filteredDdayListProvider = Provider<AsyncValue<List<DDay>>>((ref) {
  final listAsync = ref.watch(ddayListProvider);
  final filter = ref.watch(currentFilterProvider);
  final sort = ref.watch(currentSortProvider);

  return listAsync.whenData((list) {
    // Filter
    var filtered = switch (filter) {
      DdayFilter.all => list,
      DdayFilter.couple => list.where((d) => d.category == 'couple').toList(),
      DdayFilter.exam => list.where((d) => d.category == 'exam').toList(),
      DdayFilter.baby => list.where((d) => d.category == 'baby').toList(),
      DdayFilter.favorites => list.where((d) => d.isFavorite).toList(),
    };

    // Sort
    switch (sort) {
      case DdaySort.dateAsc:
        filtered.sort((a, b) => a.targetDate.compareTo(b.targetDate));
      case DdaySort.dateDesc:
        filtered.sort((a, b) => b.targetDate.compareTo(a.targetDate));
      case DdaySort.created:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case DdaySort.manual:
        filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }

    return filtered;
  });
});
