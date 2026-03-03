import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/glass_style.dart';
import '../../core/widgets/press_scale.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/purchase_providers.dart';
import '../../providers/settings_providers.dart';
import '../pro_purchase/pro_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentMode =
        ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final currentLanguage = ref.watch(languageProvider).valueOrNull;
    final milestoneAlerts =
        ref.watch(milestoneAlertsProvider).valueOrNull ?? true;
    final ddayAlerts = ref.watch(ddayAlertsProvider).valueOrNull ?? true;
    final currentSort =
        ref.watch(defaultSortProvider).valueOrNull ?? 'date_asc';

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
          horizontal: AppSpacing.pageHorizontal,
          vertical: AppConfig.lg,
        ),
        children: [
          // --- PRO banner ---
          _ProBanner(
            isDark: isDark,
            l10n: l10n,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProScreen()),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // --- APPEARANCE ---
          _SectionHeader(text: l10n.settings_appearance),
          const SizedBox(height: AppConfig.sm),
          _GlassSettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConfig.lg,
                  vertical: AppConfig.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: AppConfig.md),
                        Text(
                          l10n.settings_themeMode,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConfig.sm),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text(l10n.settings_themeModeSystem),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text(l10n.settings_themeModeLight),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text(l10n.settings_themeModeDark),
                          ),
                        ],
                        selected: {currentMode},
                        onSelectionChanged: (selected) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(selected.first);
                        },
                        style: SegmentedButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.surfaceDark
                              : Colors.grey.shade100,
                          selectedBackgroundColor:
                              AppColors.primaryColor.withValues(alpha: 0.15),
                          selectedForegroundColor: AppColors.primaryColor,
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _divider(isDark),
              _DropdownRow(
                label: l10n.settings_language,
                icon: Icons.language,
                isDark: isDark,
                value: currentLanguage ?? 'system',
                items: [
                  ('en', l10n.settings_languageEnglish),
                  ('ko', l10n.settings_languageKorean),
                ],
                onChanged: (value) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // --- NOTIFICATIONS ---
          _SectionHeader(text: l10n.settings_notifications),
          const SizedBox(height: AppConfig.sm),
          _GlassSettingsCard(
            children: [
              _ToggleRow(
                label: l10n.settings_milestoneAlerts,
                icon: Icons.flag_outlined,
                isDark: isDark,
                value: milestoneAlerts,
                onChanged: (value) {
                  ref
                      .read(milestoneAlertsProvider.notifier)
                      .setEnabled(value);
                },
              ),
              _divider(isDark),
              _ToggleRow(
                label: l10n.settings_ddayAlerts,
                icon: Icons.notifications_outlined,
                isDark: isDark,
                value: ddayAlerts,
                onChanged: (value) {
                  ref.read(ddayAlertsProvider.notifier).setEnabled(value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // --- DATA ---
          _SectionHeader(text: l10n.settings_data),
          const SizedBox(height: AppConfig.sm),
          _GlassSettingsCard(
            children: [
              _CycleSortRow(
                label: l10n.settings_defaultSort,
                isDark: isDark,
                currentSort: currentSort,
                sortLabel: _sortLabel(l10n, currentSort),
                onTap: () {
                  final next = _nextSort(currentSort);
                  ref.read(defaultSortProvider.notifier).setDefaultSort(next);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // --- ABOUT ---
          _SectionHeader(text: l10n.settings_about),
          const SizedBox(height: AppConfig.sm),
          _GlassSettingsCard(
            children: [
              _TapRow(
                label: l10n.settings_privacyPolicy,
                icon: Icons.privacy_tip_outlined,
                isDark: isDark,
                onTap: () {
                  // TODO(T-about): Open privacy policy URL
                },
              ),
              _divider(isDark),
              _TapRow(
                label: l10n.settings_termsOfService,
                icon: Icons.description_outlined,
                isDark: isDark,
                onTap: () {
                  // TODO(T-about): Open terms of service URL
                },
              ),
              _divider(isDark),
              _InfoRow(
                label: l10n.settings_appVersion,
                value: 'v0.1.0',
                icon: Icons.info_outline,
                isDark: isDark,
              ),
              _divider(isDark),
              _TapRow(
                label: l10n.settings_restorePurchase,
                icon: Icons.restore,
                isDark: isDark,
                onTap: () async {
                  try {
                    final success =
                        await ref.read(isProProvider.notifier).restore();
                    if (context.mounted) {
                      final msg = success
                          ? l10n.pro_thankYou
                          : l10n.error_restoreNone;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.error_restoreFailed)),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppConfig.xxxl),

          // --- DEBUG (only in debug builds) ---
          if (kDebugMode) ...[
            _SectionHeader(text: '\u{1F527} DEBUG'),
            const SizedBox(height: AppConfig.sm),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: _DebugProToggle(isDark: isDark, ref: ref),
            ),
            const SizedBox(height: AppConfig.xxxl),
          ],
        ],
      ),
    );
  }

  static Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );
  }

  String _sortLabel(AppLocalizations l10n, String sort) {
    return switch (sort) {
      'date_desc' => l10n.sort_farthest,
      'created' => l10n.sort_recent,
      _ => l10n.sort_nearest,
    };
  }

  String _nextSort(String current) {
    return switch (current) {
      'date_asc' => 'date_desc',
      'date_desc' => 'created',
      _ => 'date_asc',
    };
  }
}

// ---------------------------------------------------------------------------
// PRO Banner — GlassContainer + accent tint, radius 20
// ---------------------------------------------------------------------------

class _ProBanner extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _ProBanner({
    required this.isDark,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(AppConfig.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withValues(alpha: 0.12),
                  AppColors.secondaryColor.withValues(alpha: 0.08),
                ],
              ),
            ),
            child: Row(
              children: [
                const Text('\u{1F451}', style: TextStyle(fontSize: 28)),
                const SizedBox(width: AppConfig.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title — 17pt w800
                      Text(
                        l10n.settings_proBanner,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Description — 12pt
                      Text(
                        l10n.settings_proBannerDesc,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryColor.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header — 11pt, w700, uppercase, letterSpacing 1.2
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glass card container — GlassContainer blur 12, radius 18
// ---------------------------------------------------------------------------

class _GlassSettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _GlassSettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 18,
      blur: 12,
      child: Column(children: children),
    );
  }
}

// ---------------------------------------------------------------------------
// Row variants
// ---------------------------------------------------------------------------

class _DropdownRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final String value;
  final List<(String, String)> items;
  final ValueChanged<String> onChanged;

  const _DropdownRow({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.lg,
        vertical: 6,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: AppConfig.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          DropdownButton<String>(
            value: items.any((e) => e.$1 == value) ? value : items.first.$1,
            underline: const SizedBox.shrink(),
            isDense: true,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            icon: const Icon(
              Icons.expand_more,
              size: 18,
              color: AppColors.primaryColor,
            ),
            dropdownColor:
                isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e.$1,
                    child: Text(e.$2),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom toggle — 50x30, radius 15, gradient ON, spring animation
// ---------------------------------------------------------------------------

class _ToggleRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.lg,
        vertical: AppConfig.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: AppConfig.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          _CustomToggle(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Custom toggle switch — 50x30, radius 15
/// ON: gradient #6C63FF→#8B5CF6
/// OFF: #E0E0E8
/// Knob: 24px, white, boxShadow, spring animation
class _CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: value ? AppColors.primaryGradient : null,
          color: value
              ? null
              : Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF3A3A5C)
                  : const Color(0xFFE0E0E8),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          alignment:
              value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TapRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _TapRow({
    required this.label,
    required this.icon,
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
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: AppConfig.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDark
                  ? AppColors.textDisabledDark
                  : AppColors.textDisabledLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _DebugProToggle extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;

  const _DebugProToggle({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.lg,
        vertical: 4,
      ),
      child: Row(
        children: [
          Icon(
            Icons.bug_report,
            size: 20,
            color: Colors.red.withValues(alpha: 0.7),
          ),
          const SizedBox(width: AppConfig.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRO Status',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  isPro ? 'PRO: Active \u2705' : 'PRO: Inactive \u274C',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPro ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _CustomToggle(
            value: isPro,
            onChanged: (value) {
              ref.read(isProProvider.notifier).setPro(value);
            },
          ),
        ],
      ),
    );
  }
}

class _CycleSortRow extends StatelessWidget {
  final String label;
  final bool isDark;
  final String currentSort;
  final String sortLabel;
  final VoidCallback onTap;

  const _CycleSortRow({
    required this.label,
    required this.isDark,
    required this.currentSort,
    required this.sortLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.lg,
        vertical: AppConfig.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 20,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: AppConfig.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sortLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.swap_vert,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConfig.lg,
        vertical: AppConfig.md,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: AppConfig.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
