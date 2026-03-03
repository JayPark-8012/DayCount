import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/press_scale.dart';
import '../../data/constants/emoji_sets.dart';
import '../../data/models/dday.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/dday_providers.dart';
import 'widgets/category_chips.dart';
import 'widgets/emoji_selector.dart';
import 'widgets/preview_card.dart';
import 'widgets/theme_selector.dart';

class DdayFormScreen extends ConsumerStatefulWidget {
  final DDay? existingDday;

  const DdayFormScreen({super.key, this.existingDday});

  bool get isEditMode => existingDday != null;

  @override
  ConsumerState<DdayFormScreen> createState() => _DdayFormScreenState();
}

class _DdayFormScreenState extends ConsumerState<DdayFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _memoController;

  late String _emoji;
  late DateTime _selectedDate;
  late String _category;
  late String _themeId;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final dday = widget.existingDday;
    _titleController = TextEditingController(text: dday?.title ?? '');
    _memoController = TextEditingController(text: dday?.memo ?? '');
    _emoji = dday?.emoji ?? '\u{1F4C5}';
    _selectedDate =
        dday != null ? DateTime.parse(dday.targetDate) : DateTime.now();
    _category = dday?.category ?? 'anniversary';
    _themeId = dday?.themeId ?? 'cloud';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty;

  /// When category changes, auto-update emoji to the category default
  /// (only if current emoji belongs to old category set).
  void _onCategoryChanged(String newCategory) {
    final oldEmojis = emojiSets[_category] ?? [];
    setState(() {
      _category = newCategory;
      // If current emoji is from the old set or is the default placeholder,
      // switch to new category's default emoji
      if (oldEmojis.contains(_emoji) || _emoji == '\u{1F4C5}') {
        _emoji = defaultEmojiForCategory(newCategory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            widget.isEditMode ? l10n.form_titleEdit : l10n.form_titleNew,
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppConfig.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Title ──
              _buildSectionLabel(l10n.form_titleLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              TextField(
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: _inputDecoration(
                  context,
                  hintText: l10n.form_titleHint,
                ),
              ),
              const SizedBox(height: AppConfig.xxl),

              // ── 2. Date ──
              _buildSectionLabel(l10n.form_dateLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  decoration: _fieldDecoration(isDark),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateFormat.format(_selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      Text(
                        '\u{1F4C5}',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConfig.xxl),

              // ── 3. Category ──
              _buildSectionLabel(l10n.form_categoryLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              CategoryChips(
                selectedCategory: _category,
                onCategoryChanged: _onCategoryChanged,
              ),
              const SizedBox(height: AppConfig.xxl),

              // ── 4. Emoji ──
              _buildSectionLabel(l10n.form_emojiLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              EmojiSelector(
                selectedEmoji: _emoji,
                category: _category,
                onEmojiSelected: (emoji) => setState(() => _emoji = emoji),
              ),
              const SizedBox(height: AppConfig.xxl),

              // ── 5. Theme ──
              _buildSectionLabel(l10n.form_themeLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              ThemeSelector(
                selectedThemeId: _themeId,
                onThemeChanged: (id) => setState(() => _themeId = id),
              ),
              const SizedBox(height: AppConfig.xxl),

              // ── 6. Preview Card ──
              _buildSectionLabel(l10n.form_previewLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              PreviewCard(
                emoji: _emoji,
                title: _titleController.text.trim(),
                themeId: _themeId,
                targetDate: _selectedDate,
              ),
              const SizedBox(height: AppConfig.xxxl),

              // ── Save button ──
              _buildSaveButton(l10n, isDark),
              const SizedBox(height: AppConfig.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  /// Section label — 12pt, w700, textSecondary, uppercase, letterSpacing 0.5
  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
      ),
    );
  }

  /// Unified field decoration — radius 16, padding 15x18
  BoxDecoration _fieldDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark
          ? const Color(0x991A1A30) // rgba(26,26,48,0.6)
          : const Color(0xE6F5F5FC), // rgba(245,245,252,0.9)
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? const Color(0x0FFFFFFF) // rgba(255,255,255,0.06)
            : const Color(0x0A000000), // rgba(0,0,0,0.04)
      ),
    );
  }

  /// Input decoration matching the unified field style
  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color:
            isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
      ),
      filled: true,
      fillColor: isDark
          ? const Color(0x991A1A30)
          : const Color(0xE6F5F5FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark
              ? const Color(0x0FFFFFFF)
              : const Color(0x0A000000),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark
              ? const Color(0x0FFFFFFF)
              : const Color(0x0A000000),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0x446C63FF), // #6C63FF44
        ),
      ),
    );
  }

  /// Save button — active: gradient + shadow, inactive: grey
  Widget _buildSaveButton(AppLocalizations l10n, bool isDark) {
    if (_isValid) {
      return PressScale(
        onTap: () => _save(context),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              l10n.form_save,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // Disabled state
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.dividerLight,
        borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
      ),
      child: Center(
        child: Text(
          l10n.form_save,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textDisabledDark
                : AppColors.textDisabledLight,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final now = _dateFormat.format(DateTime.now());
    final memo = _memoController.text.trim().isEmpty
        ? null
        : _memoController.text.trim();
    final today = DateUtils.dateOnly(DateTime.now());
    final isCountUp = _selectedDate.isBefore(today) ||
        _selectedDate.isAtSameMomentAs(today);

    try {
      if (widget.isEditMode) {
        final updated = widget.existingDday!.copyWith(
          title: _titleController.text.trim(),
          targetDate: _dateFormat.format(_selectedDate),
          category: _category,
          emoji: _emoji,
          themeId: _themeId,
          isCountUp: isCountUp,
          memo: memo,
          updatedAt: now,
        );
        await ref.read(ddayListProvider.notifier).updateDday(updated);
      } else {
        final newDday = DDay(
          title: _titleController.text.trim(),
          targetDate: _dateFormat.format(_selectedDate),
          category: _category,
          emoji: _emoji,
          themeId: _themeId,
          isCountUp: isCountUp,
          memo: memo,
          createdAt: now,
          updatedAt: now,
        );
        await ref.read(ddayListProvider.notifier).addDday(newDday);
      }

      if (mounted) Navigator.pop(this.context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text(l10n.error_saveFailed)),
        );
      }
    }
  }
}
