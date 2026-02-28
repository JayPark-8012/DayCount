import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../data/models/dday.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/dday_providers.dart';
import 'widgets/category_chips.dart';
import 'widgets/emoji_selector.dart';
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
    _category = dday?.category ?? 'general';
    _themeId = dday?.themeId ?? 'cloud';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty;

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
            horizontal: AppConfig.xl,
            vertical: AppConfig.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji selector
              EmojiSelector(
                selectedEmoji: _emoji,
                onEmojiSelected: (emoji) => setState(() => _emoji = emoji),
              ),
              const SizedBox(height: AppConfig.xxl),

              // Title
              _buildLabel(l10n.form_titleLabel, isDark),
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

              // Date
              _buildLabel(l10n.form_dateLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius:
                        BorderRadius.circular(AppConfig.milestoneCardRadius),
                    border: Border.all(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                    ),
                  ),
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

              // Category
              CategoryChips(
                selectedCategory: _category,
                onCategoryChanged: (cat) => setState(() => _category = cat),
              ),
              const SizedBox(height: AppConfig.xxl),

              // Theme
              ThemeSelector(
                selectedThemeId: _themeId,
                onThemeChanged: (id) => setState(() => _themeId = id),
              ),
              const SizedBox(height: AppConfig.xxl),

              // Memo
              _buildLabel(l10n.form_memoLabel, isDark),
              const SizedBox(height: AppConfig.sm),
              TextField(
                controller: _memoController,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: _inputDecoration(
                  context,
                  hintText: l10n.form_memoHint,
                ),
              ),
              const SizedBox(height: AppConfig.xxxl),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isValid ? () => _save(context) : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: isDark
                        ? AppColors.surfaceDark
                        : AppColors.dividerLight,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConfig.buttonRadius),
                    ),
                  ),
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
              const SizedBox(height: AppConfig.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
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

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
      ),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        borderSide: BorderSide(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        borderSide: BorderSide(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.milestoneCardRadius),
        borderSide: const BorderSide(color: AppColors.primaryColor),
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
    final now = _dateFormat.format(DateTime.now());
    final memo = _memoController.text.trim().isEmpty
        ? null
        : _memoController.text.trim();
    final today = DateUtils.dateOnly(DateTime.now());
    final isCountUp = _selectedDate.isBefore(today) ||
        _selectedDate.isAtSameMomentAs(today);

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
  }
}
