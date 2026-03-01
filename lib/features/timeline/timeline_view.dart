import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../data/models/dday.dart';
import '../../providers/dday_providers.dart';
import '../dday_detail/detail_screen.dart';
import '../dday_form/form_screen.dart';
import '../home/widgets/empty_state.dart';
import 'widgets/timeline_node.dart';
import 'widgets/today_marker.dart';

class TimelineView extends ConsumerWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ddayAsync = ref.watch(ddayListProvider);

    return ddayAsync.when(
      data: (ddays) {
        if (ddays.isEmpty) {
          return HomeEmptyState(
            isFiltered: false,
            onCreateTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DdayFormScreen()),
            ),
          );
        }
        return _buildTimeline(context, ddays);
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

  Widget _buildTimeline(BuildContext context, List<DDay> ddays) {
    final today = DateUtils.dateOnly(DateTime.now());

    // Sort by targetDate ascending
    final sorted = List<DDay>.from(ddays)
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));

    // Split into past and future
    final past = <DDay>[];
    final future = <DDay>[];
    for (final dday in sorted) {
      final target = DateTime.parse(dday.targetDate);
      if (target.isBefore(today)) {
        past.add(dday);
      } else {
        future.add(dday);
      }
    }

    // Build item list: past nodes + today marker + future nodes
    // Each item is either a DDay or null (null = today marker)
    final items = <DDay?>[
      ...past,
      null, // TODAY marker
      ...future,
    ];

    final totalCount = items.length;

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppConfig.xl,
        right: AppConfig.xl,
        top: AppConfig.sm,
        bottom: 100,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item == null) {
          // TODAY marker
          return TodayMarker(
            isFirst: past.isEmpty,
            isLast: future.isEmpty,
          );
        }

        final isPast = index < past.length;
        // isFirst: first item in the entire list (and it's not the today marker)
        final isFirst = index == 0;
        // isLast: last item in the entire list
        final isLast = index == totalCount - 1;

        return TimelineNode(
          dday: item,
          index: index,
          isPast: isPast,
          isFirst: isFirst,
          isLast: isLast,
          onTap: () => _navigateToDetail(context, item.id!),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, int ddayId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(ddayId: ddayId)),
    );
  }
}
