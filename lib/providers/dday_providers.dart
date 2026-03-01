import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/milestone_generator.dart';
import '../data/models/dday.dart';
import '../data/repositories/dday_repository.dart';
import '../data/repositories/notification_repository.dart';
import 'milestone_providers.dart';
import 'settings_providers.dart';

final ddayRepositoryProvider = Provider<DdayRepository>((ref) {
  return DdayRepository();
});

final ddayListProvider =
    AsyncNotifierProvider<DdayListNotifier, List<DDay>>(DdayListNotifier.new);

final ddayDetailProvider =
    Provider.family<AsyncValue<DDay?>, int>((ref, ddayId) {
  final listAsync = ref.watch(ddayListProvider);
  return listAsync.whenData(
    (list) {
      try {
        return list.firstWhere((d) => d.id == ddayId);
      } catch (_) {
        return null;
      }
    },
  );
});

class DdayListNotifier extends AsyncNotifier<List<DDay>> {
  late DdayRepository _repository;

  @override
  FutureOr<List<DDay>> build() {
    _repository = ref.watch(ddayRepositoryProvider);
    return _repository.getAll();
  }

  Future<int> addDday(DDay dday) async {
    final id = await _repository.insert(dday);

    // Auto-generate milestones
    final milestones = generateMilestones(
      ddayId: id,
      category: dday.category,
    );
    final milestoneRepo = ref.read(milestoneRepositoryProvider);
    await milestoneRepo.insertAll(milestones);

    // Schedule notifications
    if (!kIsWeb) {
      final insertedMilestones = await milestoneRepo.getByDdayId(id);
      final milestoneAlerts = await ref.read(milestoneAlertsProvider.future);
      final ddayAlerts = await ref.read(ddayAlertsProvider.future);
      final locale = await ref.read(languageProvider.future);
      await NotificationRepository.instance.rescheduleAllForDday(
        dday.copyWith(id: id),
        insertedMilestones,
        milestoneAlertsEnabled: milestoneAlerts,
        ddayAlertsEnabled: ddayAlerts,
        locale: locale,
      );
    }

    ref.invalidateSelf();
    await future;
    return id;
  }

  Future<void> updateDday(DDay dday) async {
    await _repository.update(dday);

    // Reschedule notifications
    if (!kIsWeb && dday.id != null) {
      final milestoneRepo = ref.read(milestoneRepositoryProvider);
      final milestones = await milestoneRepo.getByDdayId(dday.id!);
      final milestoneAlerts = await ref.read(milestoneAlertsProvider.future);
      final ddayAlerts = await ref.read(ddayAlertsProvider.future);
      final locale = await ref.read(languageProvider.future);
      await NotificationRepository.instance.rescheduleAllForDday(
        dday,
        milestones,
        milestoneAlertsEnabled: milestoneAlerts,
        ddayAlertsEnabled: ddayAlerts,
        locale: locale,
      );
    }

    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleFavorite(DDay dday) async {
    final updated = dday.copyWith(isFavorite: !dday.isFavorite);
    await _repository.update(updated);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteDday(int id) async {
    // Cancel notifications before deleting
    if (!kIsWeb) {
      await NotificationRepository.instance.cancelAllForDday(id);
    }

    await _repository.delete(id);
    ref.invalidateSelf();
    await future;
  }
}
