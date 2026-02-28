import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../features/home/home_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final slides = [
      _SlideData(
        emoji: '\u2728',
        title: l10n.onboarding_title1,
        description: l10n.onboarding_desc1,
      ),
      _SlideData(
        emoji: '\uD83C\uDFAF',
        title: l10n.onboarding_title2,
        description: l10n.onboarding_desc2,
      ),
      _SlideData(
        emoji: '\uD83D\uDCCA',
        title: l10n.onboarding_title3,
        description: l10n.onboarding_desc3,
      ),
    ];

    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _SlidePage(
                    emoji: slide.emoji,
                    title: slide.title,
                    description: slide.description,
                    isDark: isDark,
                  );
                },
              ),
            ),

            // Dot indicator
            Padding(
              padding: const EdgeInsets.only(bottom: AppConfig.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => _DotIndicator(isActive: index == _currentPage),
                ),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConfig.xxl),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConfig.buttonRadius),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _onNext(isLastPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConfig.buttonRadius),
                      ),
                    ),
                    child: Text(
                      isLastPage
                          ? l10n.onboarding_getStarted
                          : l10n.onboarding_next,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Skip button
            Padding(
              padding: const EdgeInsets.only(
                top: AppConfig.md,
                bottom: AppConfig.xxxl,
              ),
              child: TextButton(
                onPressed: _onSkip,
                child: Text(
                  l10n.onboarding_skip,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext(bool isLastPage) {
    if (isLastPage) {
      _completeOnboarding(skipped: false);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    _completeOnboarding(skipped: true);
  }

  Future<void> _completeOnboarding({required bool skipped}) async {
    await ref.read(onboardingDoneProvider.notifier).setDone();

    // TODO(T-analytics): log onboarding_complete event (skipped: skipped)

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}

// --- Slide data ---

class _SlideData {
  final String emoji;
  final String title;
  final String description;

  const _SlideData({
    required this.emoji,
    required this.title,
    required this.description,
  });
}

// --- Slide page ---

class _SlidePage extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isDark;

  const _SlidePage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  State<_SlidePage> createState() => _SlidePageState();
}

class _SlidePageState extends State<_SlidePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConfig.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji with pulse animation
          ScaleTransition(
            scale: _pulseAnimation,
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 72),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: widget.isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConfig.lg),

          // Description
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: widget.isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// --- Dot indicator ---

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryColor
            : AppColors.primaryColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
