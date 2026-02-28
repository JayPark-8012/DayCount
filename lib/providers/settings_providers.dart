import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

// --- Setting keys ---
const _keyThemeMode = 'theme_mode';
const _keyLanguage = 'language';
const _keyDefaultSort = 'default_sort';
const _keyOnboardingDone = 'onboarding_done';
const _keyMilestoneAlerts = 'milestone_alerts_enabled';
const _keyDdayAlerts = 'dday_alerts_enabled';

// --- ThemeMode ---
final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  late SettingsRepository _repository;

  @override
  FutureOr<ThemeMode> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    final value = await _repository.getString(
      _keyThemeMode,
      defaultValue: 'system',
    );
    return _parseThemeMode(value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await _repository.set(_keyThemeMode, mode.name);
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

// --- Language ---
final languageProvider =
    AsyncNotifierProvider<LanguageNotifier, String?>(LanguageNotifier.new);

class LanguageNotifier extends AsyncNotifier<String?> {
  late SettingsRepository _repository;

  @override
  FutureOr<String?> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    final value = await _repository.get(_keyLanguage);
    return value; // null = system default
  }

  Future<void> setLanguage(String? languageCode) async {
    state = AsyncData(languageCode);
    await _repository.set(_keyLanguage, languageCode);
  }
}

// --- Default sort ---
final defaultSortProvider =
    AsyncNotifierProvider<DefaultSortNotifier, String>(
  DefaultSortNotifier.new,
);

class DefaultSortNotifier extends AsyncNotifier<String> {
  late SettingsRepository _repository;

  @override
  FutureOr<String> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    return _repository.getString(
      _keyDefaultSort,
      defaultValue: 'date_asc',
    );
  }

  Future<void> setDefaultSort(String sort) async {
    state = AsyncData(sort);
    await _repository.set(_keyDefaultSort, sort);
  }
}

// --- Onboarding done ---
final onboardingDoneProvider =
    AsyncNotifierProvider<OnboardingDoneNotifier, bool>(
  OnboardingDoneNotifier.new,
);

class OnboardingDoneNotifier extends AsyncNotifier<bool> {
  late SettingsRepository _repository;

  @override
  FutureOr<bool> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    return _repository.getBool(_keyOnboardingDone, defaultValue: false);
  }

  Future<void> setDone() async {
    state = const AsyncData(true);
    await _repository.set(_keyOnboardingDone, 'true');
  }
}

// --- Milestone alerts ---
final milestoneAlertsProvider =
    AsyncNotifierProvider<MilestoneAlertsNotifier, bool>(
  MilestoneAlertsNotifier.new,
);

class MilestoneAlertsNotifier extends AsyncNotifier<bool> {
  late SettingsRepository _repository;

  @override
  FutureOr<bool> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    return _repository.getBool(_keyMilestoneAlerts, defaultValue: true);
  }

  Future<void> setEnabled(bool enabled) async {
    state = AsyncData(enabled);
    await _repository.set(_keyMilestoneAlerts, enabled.toString());
  }
}

// --- D-Day alerts ---
final ddayAlertsProvider =
    AsyncNotifierProvider<DdayAlertsNotifier, bool>(
  DdayAlertsNotifier.new,
);

class DdayAlertsNotifier extends AsyncNotifier<bool> {
  late SettingsRepository _repository;

  @override
  FutureOr<bool> build() async {
    _repository = ref.watch(settingsRepositoryProvider);
    return _repository.getBool(_keyDdayAlerts, defaultValue: true);
  }

  Future<void> setEnabled(bool enabled) async {
    state = AsyncData(enabled);
    await _repository.set(_keyDdayAlerts, enabled.toString());
  }
}
