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
}
