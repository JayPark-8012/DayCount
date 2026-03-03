import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/theme/glass_style.dart';
import '../../../data/constants/emoji_sets.dart';

class EmojiSelector extends StatelessWidget {
  final String selectedEmoji;
  final String category;
  final ValueChanged<String> onEmojiSelected;

  const EmojiSelector({
    super.key,
    required this.selectedEmoji,
    required this.category,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emojis = emojiSets[category] ?? emojiSets['anniversary']!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: large selected emoji — 56x56, radius 16, GlassContainer
        GestureDetector(
          onTap: () => _showFullEmojiPicker(context),
          child: GlassContainer(
            borderRadius: 16,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: Text(
                  selectedEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConfig.lg),

        // Right: category emoji grid — 10 emojis, 5x2, 38x38
        Expanded(
          child: Wrap(
            spacing: AppConfig.sm,
            runSpacing: AppConfig.sm,
            children: emojis.map((emoji) {
              final isSelected = emoji == selectedEmoji;
              return GestureDetector(
                onTap: () => onEmojiSelected(emoji),
                child: AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.08)
                          : isDark
                              ? const Color(0x1AFFFFFF)
                              : const Color(0x0D000000),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showFullEmojiPicker(BuildContext context) {
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
