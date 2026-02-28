import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../data/models/dday.dart';
import '../../data/models/milestone.dart';
import '../../l10n/app_localizations.dart';

class CelebrationDialog extends StatefulWidget {
  final DDay dday;
  final Milestone milestone;
  final VoidCallback onDismiss;
  final VoidCallback onShare;

  const CelebrationDialog({
    super.key,
    required this.dday,
    required this.milestone,
    required this.onDismiss,
    required this.onShare,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      body: Stack(
        children: [
          // Content
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConfig.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Celebration emoji
                  const Text(
                    '\u{1F389}',
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: AppConfig.xxl),

                  // "Congratulations!"
                  Text(
                    l10n.celebration_congratulations,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConfig.xl),

                  // D-Day emoji + title
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.dday.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: AppConfig.sm),
                      Flexible(
                        child: Text(
                          widget.dday.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConfig.sm),

                  // "reached"
                  Text(
                    l10n.celebration_reached,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppConfig.xs),

                  // Milestone label
                  Text(
                    '${widget.milestone.label}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Share This button
                  SizedBox(
                    width: 240,
                    child: FilledButton.icon(
                      onPressed: widget.onShare,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConfig.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConfig.buttonRadius),
                        ),
                      ),
                      icon: const Text(
                        '\u{1F4E4}',
                        style: TextStyle(fontSize: 16),
                      ),
                      label: Text(
                        l10n.celebration_shareThis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConfig.md),

                  // Dismiss button
                  SizedBox(
                    width: 240,
                    child: OutlinedButton(
                      onPressed: widget.onDismiss,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConfig.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConfig.buttonRadius),
                        ),
                      ),
                      child: Text(
                        l10n.celebration_dismiss,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti — fires from top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi / 2,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              emissionFrequency: 0.05,
              colors: const [
                AppColors.primaryColor,
                AppColors.secondaryColor,
                AppColors.accentColor,
                Colors.amber,
                Colors.lightGreen,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCelebrationDialog(
  BuildContext context, {
  required DDay dday,
  required Milestone milestone,
  required VoidCallback onDismiss,
  required VoidCallback onShare,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    pageBuilder: (_, _, _) => CelebrationDialog(
      dday: dday,
      milestone: milestone,
      onDismiss: onDismiss,
      onShare: onShare,
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
