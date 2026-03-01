import 'package:firebase_analytics/firebase_analytics.dart';

/// Centralized analytics event helpers.
class Analytics {
  static FirebaseAnalytics get _instance => FirebaseAnalytics.instance;

  static Future<void> logShareCardPhotoUsed() =>
      _instance.logEvent(name: 'share_card_photo_used');

  static Future<void> logShareCardFontChanged(String fontName) =>
      _instance.logEvent(
        name: 'share_card_font_changed',
        parameters: {'font_name': fontName},
      );
}
