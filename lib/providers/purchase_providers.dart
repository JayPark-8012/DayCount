import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_providers.dart';

const _keyIsPro = 'is_pro';

final isProProvider =
    AsyncNotifierProvider<IsProNotifier, bool>(IsProNotifier.new);

class IsProNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.getBool(_keyIsPro, defaultValue: false);
  }

  Future<void> setPro(bool value) async {
    state = AsyncData(value);
    await ref.read(settingsRepositoryProvider).set(
          _keyIsPro,
          value.toString(),
        );
  }
}
