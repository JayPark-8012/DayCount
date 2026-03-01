import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/purchase_providers.dart';

class ProScreen extends ConsumerStatefulWidget {
  const ProScreen({super.key});

  @override
  ConsumerState<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends ConsumerState<ProScreen>
    with TickerProviderStateMixin {
  bool _isProcessing = false;

  // Crown shimmer animation
  late final AnimationController _crownController;
  late final Animation<double> _crownScale;
  late final Animation<double> _crownRotate;

  // Feature cards stagger animation
  late final AnimationController _cardsController;
  late final List<Animation<double>> _cardOpacities;
  late final List<Animation<Offset>> _cardSlides;

  @override
  void initState() {
    super.initState();

    // Crown shimmer: scale 1→1.08→1, rotate ±3deg, 2s infinite
    _crownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _crownScale = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _crownController, curve: Curves.easeInOut),
    );
    _crownRotate = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _crownController, curve: Curves.easeInOut),
    );

    // Feature cards: fadeSlideIn, stagger 50ms
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _cardOpacities = List.generate(3, (i) {
      final start = i * 0.11; // ~50ms stagger in 450ms
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start, (start + 0.67).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });
    _cardSlides = List.generate(3, (i) {
      final start = i * 0.11;
      return Tween(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start, (start + 0.67).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });

    _cardsController.forward();
  }

  @override
  void dispose() {
    _crownController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  Future<void> _onPurchase() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final success = await ref.read(isProProvider.notifier).purchase();
      if (success && mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pro_thankYou)),
        );
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      if (e.code != 'PURCHASE_CANCELLED' && mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error_purchaseFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onRestore() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final success = await ref.read(isProProvider.notifier).restore();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final msg =
            success ? l10n.pro_thankYou : l10n.error_restoreNone;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        if (success) Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error_restoreFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPro = ref.watch(isProProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D1B69)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppConfig.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: AppConfig.xxl),

                      // Crown shimmer
                      AnimatedBuilder(
                        animation: _crownController,
                        builder: (_, _) => Transform.scale(
                          scale: _crownScale.value,
                          child: Transform.rotate(
                            angle: _crownRotate.value,
                            child: const Text(
                              '\u{1F451}',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConfig.lg),

                      // Title
                      Text(
                        l10n.pro_title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppConfig.xs),
                      Text(
                        l10n.pro_subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA0A0C0),
                        ),
                      ),

                      const SizedBox(height: AppConfig.xxxl),

                      // Feature cards
                      _buildFeatureCard(
                        0,
                        '\u{1F3A8}',
                        l10n.pro_feature1Title,
                        l10n.pro_feature1Desc,
                      ),
                      const SizedBox(height: AppConfig.md),
                      _buildFeatureCard(
                        1,
                        '\u{1F495}',
                        l10n.pro_feature2Title,
                        l10n.pro_feature2Desc,
                      ),
                      const SizedBox(height: AppConfig.md),
                      _buildFeatureCard(
                        2,
                        '\u{1F4E4}',
                        l10n.pro_feature3Title,
                        l10n.pro_feature3Desc,
                      ),

                      const SizedBox(height: AppConfig.xxxl),

                      // Price
                      Text(
                        l10n.pro_price,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppConfig.xs),
                      Text(
                        l10n.pro_priceDesc,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFA0A0C0),
                        ),
                      ),

                      const SizedBox(height: AppConfig.xxl),

                      // CTA or Already PRO
                      if (isPro) ...[
                        const Text(
                          '\u{2728}',
                          style: TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: AppConfig.sm),
                        Text(
                          l10n.pro_already,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConfig.xs),
                        Text(
                          l10n.pro_alreadyDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA0A0C0),
                          ),
                        ),
                      ] else ...[
                        // Gold CTA button
                        GestureDetector(
                          onTap: _isProcessing ? null : _onPurchase,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFA500),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConfig.buttonRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isProcessing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text(
                                      l10n.pro_unlock,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConfig.lg),

                        // Restore purchase
                        TextButton(
                          onPressed: _isProcessing ? null : _onRestore,
                          child: Text(
                            l10n.pro_restore,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666680),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: AppConfig.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    int index,
    String emoji,
    String title,
    String desc,
  ) {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (_, _) => Opacity(
        opacity: _cardOpacities[index].value,
        child: SlideTransition(
          position: _cardSlides[index],
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConfig.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: AppConfig.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA0A0C0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
