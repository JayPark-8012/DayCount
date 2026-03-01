import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/purchase_repository.dart';
import 'settings_providers.dart';

const _keyIsPro = 'is_pro';

final purchaseRepoProvider = Provider((_) => PurchaseRepository());

final isProProvider =
    AsyncNotifierProvider<IsProNotifier, bool>(IsProNotifier.new);

class IsProNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    if (kIsWeb) {
      return ref
          .watch(settingsRepositoryProvider)
          .getBool(_keyIsPro, defaultValue: false);
    }

    // Try RevenueCat first, fall back to cached value on error
    try {
      final repo = ref.watch(purchaseRepoProvider);
      final isPro = await repo.checkProStatus();
      // Sync cache
      await ref
          .read(settingsRepositoryProvider)
          .set(_keyIsPro, isPro.toString());
      return isPro;
    } catch (e) {
      debugPrint('RevenueCat check failed, using cache: $e');
      return ref
          .watch(settingsRepositoryProvider)
          .getBool(_keyIsPro, defaultValue: false);
    }
  }

  Future<void> setPro(bool value) async {
    state = AsyncData(value);
    await ref.read(settingsRepositoryProvider).set(
          _keyIsPro,
          value.toString(),
        );
  }

  /// Execute PRO purchase via RevenueCat.
  Future<bool> purchase() async {
    final repo = ref.read(purchaseRepoProvider);
    final success = await repo.purchasePro();
    if (success) await setPro(true);
    return success;
  }

  /// Restore previous purchases via RevenueCat.
  Future<bool> restore() async {
    final repo = ref.read(purchaseRepoProvider);
    final success = await repo.restorePurchases();
    if (success) await setPro(true);
    return success;
  }
}
