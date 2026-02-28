import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../l10n/app_localizations.dart';

class EmojiSelector extends StatelessWidget {
  final String selectedEmoji;
  final ValueChanged<String> onEmojiSelected;

  const EmojiSelector({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.form_emojiLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppConfig.sm),
        GestureDetector(
          onTap: () => _showEmojiPicker(context),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Center(
              child: Text(
                selectedEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmojiPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            onEmojiSelected: (_, emoji) {
              onEmojiSelected(emoji.emoji);
              Navigator.pop(context);
            },
            config: Config(
              categoryViewConfig: CategoryViewConfig(
                indicatorColor: AppColors.primaryColor,
                iconColorSelected: AppColors.primaryColor,
                backspaceColor: AppColors.primaryColor,
                backgroundColor: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                recentTabBehavior: RecentTabBehavior.RECENT,
              ),
              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                emojiSizeMax: 28,
                recentsLimit: 28,
                backgroundColor: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
              ),
              skinToneConfig: SkinToneConfig(
                enabled: true,
                dialogBackgroundColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                indicatorColor: AppColors.primaryColor,
              ),
              bottomActionBarConfig: const BottomActionBarConfig(
                enabled: false,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
