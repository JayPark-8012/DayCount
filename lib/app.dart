import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
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

    final onboardingDone =
        ref.watch(onboardingDoneProvider).valueOrNull ?? true;

    return MaterialApp(
      title: 'DayCount',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
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
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorSchemeSeed: AppColors.primaryColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorSchemeSeed: AppColors.primaryColor,
      ),
      home: onboardingDone ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
