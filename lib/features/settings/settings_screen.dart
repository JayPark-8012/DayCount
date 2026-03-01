import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
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
          horizontal: AppConfig.xl,
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
          const SizedBox(height: AppConfig.xxl),

          // --- APPEARANCE ---
          _SectionHeader(text: l10n.settings_appearance, isDark: isDark),
          const SizedBox(height: AppConfig.sm),
          _SettingsCard(
            isDark: isDark,
            children: [
              _DropdownRow(
                label: l10n.settings_themeMode,
                icon: Icons.palette_outlined,
                isDark: isDark,
                value: currentMode.name,
                items: [
                  (ThemeMode.system.name, l10n.settings_themeModeSystem),
                  (ThemeMode.light.name, l10n.settings_themeModeLight),
                  (ThemeMode.dark.name, l10n.settings_themeModeDark),
                ],
                onChanged: (value) {
                  final mode = ThemeMode.values.firstWhere(
                    (m) => m.name == value,
                    orElse: () => ThemeMode.system,
                  );
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                },
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
          const SizedBox(height: AppConfig.xxl),

          // --- NOTIFICATIONS ---
          _SectionHeader(text: l10n.settings_notifications, isDark: isDark),
          const SizedBox(height: AppConfig.sm),
          _SettingsCard(
            isDark: isDark,
            children: [
              _SwitchRow(
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
              _SwitchRow(
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
          const SizedBox(height: AppConfig.xxl),

          // --- DATA ---
          _SectionHeader(text: l10n.settings_data, isDark: isDark),
          const SizedBox(height: AppConfig.sm),
          _SettingsCard(
            isDark: isDark,
            children: [
              _DropdownRow(
                label: l10n.settings_defaultSort,
                icon: Icons.sort,
                isDark: isDark,
                value: currentSort,
                items: [
                  ('date_asc', l10n.settings_sortDateAsc),
                  ('date_desc', l10n.settings_sortDateDesc),
                  ('created', l10n.settings_sortCreated),
                  ('manual', l10n.settings_sortManual),
                ],
                onChanged: (value) {
                  ref.read(defaultSortProvider.notifier).setDefaultSort(value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppConfig.xxl),

          // --- ABOUT ---
          _SectionHeader(text: l10n.settings_about, isDark: isDark),
          const SizedBox(height: AppConfig.sm),
          _SettingsCard(
            isDark: isDark,
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
                },
              ),
            ],
          ),
          const SizedBox(height: AppConfig.xxxl),

          // --- DEBUG (only in debug builds) ---
          if (kDebugMode) ...[
            _SectionHeader(
              text: '\u{1F527} DEBUG',
              isDark: isDark,
            ),
            const SizedBox(height: AppConfig.sm),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius:
                    BorderRadius.circular(AppConfig.milestoneCardRadius),
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
}

// ---------------------------------------------------------------------------
// PRO Banner
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConfig.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        ),
        child: Row(
          children: [
            const Text('\u{1F451}', style: TextStyle(fontSize: 28)),
            const SizedBox(width: AppConfig.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings_proBanner,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.settings_proBannerDesc,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SectionHeader({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card container
// ---------------------------------------------------------------------------

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
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
            style: TextStyle(
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

class _SwitchRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
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
        vertical: 4,
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
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryColor,
            onChanged: onChanged,
          ),
        ],
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
          Switch(
            value: isPro,
            activeThumbColor: Colors.green,
            activeTrackColor: Colors.green.withValues(alpha: 0.4),
            onChanged: (value) {
              ref.read(isProProvider.notifier).setPro(value);
            },
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
