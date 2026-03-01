import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../data/models/card_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/purchase_providers.dart';
import '../../pro_purchase/pro_screen.dart';

class ThemeSelector extends ConsumerWidget {
  final String selectedThemeId;
  final ValueChanged<String> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.selectedThemeId,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;
    final themes = cardThemes.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.form_themeLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppConfig.sm),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: themes.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppConfig.sm),
            itemBuilder: (context, index) {
              final theme = themes[index];
              final isSelected = theme.id == selectedThemeId;
              final isLocked = theme.isPro && !isPro;
              return _ThemeCircle(
                theme: theme,
                isSelected: isSelected,
                isLocked: isLocked,
                proLabel: l10n.form_proBadge,
                onTap: () {
                  if (isLocked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProScreen(),
                      ),
                    );
                    return;
                  }
                  onThemeChanged(theme.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeCircle extends StatelessWidget {
  final DdayCardTheme theme;
  final bool isSelected;
  final bool isLocked;
  final String proLabel;
  final VoidCallback onTap;

  const _ThemeCircle({
    required this.theme,
    required this.isSelected,
    required this.isLocked,
    required this.proLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = theme.background as LinearGradient;
    final startColor = gradient.colors.first;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Circle
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: startColor,
                  borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
                  border: isSelected
                      ? Border.all(color: AppColors.primaryColor, width: 2.5)
                      : null,
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 20),
                      )
                    : null,
              ),
            ),
            // PRO badge
            if (isLocked)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    proLabel,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
