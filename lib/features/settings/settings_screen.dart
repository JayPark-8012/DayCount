import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeModeAsync = ref.watch(themeModeProvider);
    final currentMode = themeModeAsync.valueOrNull ?? ThemeMode.system;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settings_title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.xl,
          vertical: AppConfig.lg,
        ),
        children: [
          // Theme mode section
          _SectionLabel(
            text: l10n.settings_themeMode,
            isDark: isDark,
          ),
          const SizedBox(height: AppConfig.sm),
          _ThemeModeSelector(
            currentMode: currentMode,
            isDark: isDark,
            l10n: l10n,
            onChanged: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SectionLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final bool isDark;
  final AppLocalizations l10n;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeSelector({
    required this.currentMode,
    required this.isDark,
    required this.l10n,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      (ThemeMode.system, l10n.settings_themeModeSystem, Icons.brightness_auto),
      (ThemeMode.light, l10n.settings_themeModeLight, Icons.light_mode),
      (ThemeMode.dark, l10n.settings_themeModeDark, Icons.dark_mode),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            _ThemeModeOption(
              mode: options[i].$1,
              label: options[i].$2,
              icon: options[i].$3,
              isSelected: currentMode == options[i].$1,
              isDark: isDark,
              onTap: () => onChanged(options[i].$1),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.lg,
          vertical: AppConfig.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primaryColor
                  : isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: AppConfig.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
