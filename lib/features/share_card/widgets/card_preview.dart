import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/card_themes.dart';
import '../../../core/utils/date_calc.dart';
import '../../../data/models/dday.dart';
import '../../../l10n/app_localizations.dart';

/// 1:1 square card preview for the share screen.
/// Wrapped with [RepaintBoundary] for PNG capture.
class CardPreview extends StatelessWidget {
  final GlobalKey cardKey;
  final DDay dday;
  final String themeId;
  final File? photoFile;
  final String? fontFamily;
  final bool showWatermark;

  const CardPreview({
    super.key,
    required this.cardKey,
    required this.dday,
    required this.themeId,
    this.photoFile,
    this.fontFamily,
    this.showWatermark = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = getCardTheme(themeId);
    final targetDate = DateTime.parse(dday.targetDate);
    final diff = daysDiff(targetDate, today());

    final dayCount = _formatDayCount(l10n, diff);
    final subtitle = _formatSubtitle(l10n, diff, dday.category);

    final isPhoto = photoFile != null;
    final textColor = isPhoto ? Colors.white : theme.textColor;
    final accentColor = isPhoto ? Colors.white : theme.accentColor;

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: isPhoto ? null : theme.background,
          color: isPhoto ? Colors.black : null,
          borderRadius: BorderRadius.circular(AppConfig.shareCardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // ── Photo background layers ──
            if (isPhoto) ...[
              Positioned.fill(
                child: Image.file(photoFile!, fit: BoxFit.cover),
              ),
              // Dark overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
              // Bottom gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              // ── Color mode: decorative circles ──
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ],

            // ── Main content ──
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dday.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dday.title,
                    style: _applyFont(TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    )),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dayCount,
                    style: _applyFont(TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: -3.0,
                    )),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ── Watermark (free users only) ──
            if (showWatermark)
              Positioned(
                right: 20,
                bottom: 16,
                child: Text(
                  l10n.common_appName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle _applyFont(TextStyle base) {
    if (fontFamily == null) return base;
    return GoogleFonts.getFont(fontFamily!, textStyle: base);
  }

  String _formatDayCount(AppLocalizations l10n, int diff) {
    if (diff == 0) return l10n.share_dDay;
    if (diff > 0) return '$diff';
    return '+${diff.abs()}';
  }

  String _formatSubtitle(AppLocalizations l10n, int diff, String category) {
    if (diff == 0) return l10n.share_today;
    if (diff > 0) return l10n.share_daysLeft;
    if (category == 'couple') return l10n.share_daysTogether;
    return l10n.share_daysSince;
  }
}
