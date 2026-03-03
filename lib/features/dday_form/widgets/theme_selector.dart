import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
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
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;
    final themes = cardThemes.values.toList();

    return SizedBox(
      height: 62, // 54 + room for shadow/scale overflow
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSelected = theme.id == selectedThemeId;
          final isLocked = theme.isPro && !isPro;
          return _ThemeTile(
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
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final DdayCardTheme theme;
  final bool isSelected;
  final bool isLocked;
  final String proLabel;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.theme,
    required this.isSelected,
    required this.isLocked,
    required this.proLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: SizedBox(
          width: 58, // 54 + border space
          height: 62,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Theme square — 54x54, radius 16, gradient preview
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: theme.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: theme.textColor,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
              // PRO badge — gradient
              if (isLocked)
                Positioned(
                  top: 0,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      proLabel,
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
