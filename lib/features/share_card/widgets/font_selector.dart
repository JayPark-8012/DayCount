import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/utils/analytics_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/purchase_providers.dart';
import '../../pro_purchase/pro_screen.dart';

class _FontItem {
  final String name;
  final bool isPro;

  const _FontItem({required this.name, required this.isPro});
}

const _fonts = [
  _FontItem(name: 'Outfit', isPro: false),
  _FontItem(name: 'Caveat', isPro: true),
  _FontItem(name: 'Dancing Script', isPro: true),
  _FontItem(name: 'Poppins', isPro: true),
  _FontItem(name: 'Playfair Display', isPro: true),
];

/// Horizontal scrolling font selector with PRO badges.
class FontSelector extends ConsumerWidget {
  final String selectedFont;
  final ValueChanged<String> onSelect;

  const FontSelector({
    super.key,
    required this.selectedFont,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
          child: Text(
            l10n.share_font,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(height: AppConfig.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
          child: Row(
            children: _fonts.map((font) {
              final isSelected = font.name == selectedFont;
              final isLocked = font.isPro && !isPro;

              return Padding(
                padding: const EdgeInsets.only(right: AppConfig.sm),
                child: GestureDetector(
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
                    onSelect(font.name);
                    Analytics.logShareCardFontChanged(font.name);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: isDark
                                      ? AppColors.textDisabledDark
                                      : AppColors.textDisabledLight,
                                ),
                        ),
                        child: Text(
                          font.name,
                          style: GoogleFonts.getFont(
                            font.name,
                            textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ),
                      if (isLocked)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.form_proBadge,
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
            }).toList(),
          ),
        ),
      ],
    );
  }
}
