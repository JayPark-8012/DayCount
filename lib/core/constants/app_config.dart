class AppConfig {
  AppConfig._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Border radius
  static const double cardRadius = 20;
  static const double milestoneCardRadius = 14;
  static const double chipRadius = 20;
  static const double buttonRadius = 16;
  static const double iconButtonRadius = 10;
  static const double fabRadius = 18;
  static const double logoRadius = 10;

  // Animation
  static const Duration cardAnimDuration = Duration(milliseconds: 400);
  static const Duration cardStaggerDelay = Duration(milliseconds: 80);
  static const Duration chipAnimDuration = Duration(milliseconds: 200);
  static const Duration fabAnimDuration = Duration(milliseconds: 200);

  // Animation — Timeline
  static const Duration viewSwitchDuration = Duration(milliseconds: 300);
  static const Duration timelineStaggerDelay = Duration(milliseconds: 100);
  static const Duration todayGlowDuration = Duration(milliseconds: 2000);

  // Home — Hero Card
  static const double heroCardRadius = 28;
  static const double heroCardMinHeight = 180;

  // Home — List Card
  static const double listCardRadius = 22;

  // Home — Segment Tab
  static const double segmentRadius = 16;
  static const Duration segmentAnimDuration = Duration(milliseconds: 300);

  // Home — Stagger
  static const Duration staggerDelay = Duration(milliseconds: 70);

  // Share Card
  static const double shareCardRadius = 28;

  // Detail Screen
  static const double detailHeaderRadius = 36;
  static const double detailMilestoneNodeSize = 32;
  static const double detailSubCountRadius = 16;
  static const double detailShareRadius = 18;
}
