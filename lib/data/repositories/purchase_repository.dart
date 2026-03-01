import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat wrapper for DayCount PRO in-app purchase.
class PurchaseRepository {
  static const _apiKeyIos = 'appl_PLACEHOLDER';
  static const _apiKeyAndroid = 'goog_PLACEHOLDER';
  static const _entitlementId = 'pro';

  /// Initialize RevenueCat SDK. Call once in main().
  static Future<void> init() async {
    final config = PurchasesConfiguration(
      Platform.isIOS ? _apiKeyIos : _apiKeyAndroid,
    );
    await Purchases.configure(config);
  }

  /// Check current PRO entitlement status from RevenueCat.
  Future<bool> checkProStatus() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(_entitlementId);
  }

  /// Execute PRO purchase. Returns true if entitlement is now active.
  Future<bool> purchasePro() async {
    final offerings = await Purchases.getOfferings();
    final package = offerings.current?.lifetime;
    if (package == null) return false;
    final result = await Purchases.purchasePackage(package);
    return result.entitlements.active.containsKey(_entitlementId);
  }

  /// Restore previous purchases. Returns true if PRO entitlement found.
  Future<bool> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    return info.entitlements.active.containsKey(_entitlementId);
  }
}
