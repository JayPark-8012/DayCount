import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/purchase_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize timezone data
  NotificationRepository.initializeTimeZones();

  // Initialize notification plugin and RevenueCat (skip on web)
  if (!kIsWeb) {
    await NotificationRepository.instance.initialize();
    await PurchaseRepository.init();
  }

  runApp(const ProviderScope(child: DayCountApp()));
}
