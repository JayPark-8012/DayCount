import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/utils/share_utils.dart';
import '../../data/models/dday.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/card_preview.dart';
import 'widgets/template_selector.dart';

class ShareCardScreen extends StatefulWidget {
  final DDay dday;

  const ShareCardScreen({super.key, required this.dday});

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final _cardKey = GlobalKey();
  late String _selectedThemeId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedThemeId = widget.dday.themeId;
  }

  Future<void> _onSave() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final bytes = await captureCard(_cardKey);
      final path = await saveTempFile(bytes);
      await shareImage(path);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onShare() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final bytes = await captureCard(_cardKey);
      final path = await saveTempFile(bytes);
      await shareImage(path);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.share_title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Card preview
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConfig.shareCardRadius,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 50,
                          offset: Offset(0, 20),
                        ),
                      ],
                    ),
                    child: CardPreview(
                      cardKey: _cardKey,
                      dday: widget.dday,
                      themeId: _selectedThemeId,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppConfig.lg),

          // Template selector
          TemplateSelector(
            currentThemeId: _selectedThemeId,
            onSelect: (id) => setState(() => _selectedThemeId = id),
          ),

          const SizedBox(height: AppConfig.xxl),

          // Save + Share buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConfig.xl),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _onSave,
                    icon: const Text(
                      '\u{1F4BE}',
                      style: TextStyle(fontSize: 16),
                    ),
                    label: Text(l10n.share_save),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConfig.buttonRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConfig.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isProcessing ? null : _onShare,
                    icon: const Text(
                      '\u{1F4E4}',
                      style: TextStyle(fontSize: 16),
                    ),
                    label: Text(l10n.share_share),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConfig.buttonRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConfig.xxxl),
        ],
      ),
    );
  }
}
