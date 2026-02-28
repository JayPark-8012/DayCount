import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dday.dart';
import '../data/repositories/dday_repository.dart';

final ddayRepositoryProvider = Provider<DdayRepository>((ref) {
  return DdayRepository();
});

final ddayListProvider =
    AsyncNotifierProvider<DdayListNotifier, List<DDay>>(DdayListNotifier.new);

class DdayListNotifier extends AsyncNotifier<List<DDay>> {
  late final DdayRepository _repository;

  @override
  FutureOr<List<DDay>> build() {
    _repository = ref.watch(ddayRepositoryProvider);
    return _repository.getAll();
  }

  Future<int> addDday(DDay dday) async {
    final id = await _repository.insert(dday);
    ref.invalidateSelf();
    await future;
    return id;
  }

  Future<void> updateDday(DDay dday) async {
    await _repository.update(dday);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteDday(int id) async {
    await _repository.delete(id);
    ref.invalidateSelf();
    await future;
  }
}
