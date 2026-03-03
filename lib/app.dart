import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_providers.dart';

class DayCountApp extends ConsumerWidget {
  const DayCountApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode =
        themeModeAsync.valueOrNull ?? ThemeMode.system;

    final languageCode = ref.watch(languageProvider).valueOrNull;
    final locale = languageCode != null ? Locale(languageCode) : null;

    return MaterialApp(
      title: 'DayCount',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const _AppGate(),
    );
  }
}

/// Router widget that stays as the single [MaterialApp.home].
/// Watches onboarding state internally so MaterialApp never changes `home`,
/// avoiding the issue where MaterialApp ignores `home` changes after
/// the initial Navigator is created.
class _AppGate extends ConsumerWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingDoneProvider);

    return onboardingAsync.when(
      loading: () => const Scaffold(body: SizedBox.shrink()),
      error: (_, _) => const HomeScreen(),
      data: (done) => done ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
