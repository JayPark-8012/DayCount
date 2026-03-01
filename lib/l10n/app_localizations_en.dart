// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_appName => 'DayCount';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_save => 'Save';

  @override
  String get home_title => 'DayCount';

  @override
  String get home_filterAll => 'All';

  @override
  String get home_filterCouple => 'Couple';

  @override
  String get home_filterExam => 'Exam';

  @override
  String get home_filterBaby => 'Baby';

  @override
  String get home_filterFavorites => 'Favs';

  @override
  String home_daysLeft(int count) {
    return '$count days left';
  }

  @override
  String home_daysAgo(int count) {
    return '+$count days ago';
  }

  @override
  String get home_dDay => 'D-Day!';

  @override
  String get home_emptyTitle => 'Add your first D-Day!';

  @override
  String get home_emptySubtitle =>
      'Track your important dates\nwith beautiful cards.';

  @override
  String get home_emptyButton => 'Create D-Day';

  @override
  String get home_filterEmptyTitle => 'No D-Days found';

  @override
  String get home_filterEmptySubtitle => 'Try a different filter.';

  @override
  String get home_edit => 'Edit';

  @override
  String get home_favorite => 'Favorite';

  @override
  String get home_unfavorite => 'Unfavorite';

  @override
  String get home_deleteConfirmTitle => 'Delete D-Day?';

  @override
  String get home_deleteConfirmMessage =>
      'This will permanently delete this D-Day and all its milestones.';

  @override
  String get form_titleNew => 'New D-Day';

  @override
  String get form_titleEdit => 'Edit D-Day';

  @override
  String get form_emojiLabel => 'Emoji';

  @override
  String get form_emojiHint => 'Tap to select';

  @override
  String get form_titleLabel => 'Title';

  @override
  String get form_titleHint => 'Enter D-Day title';

  @override
  String get form_dateLabel => 'Date';

  @override
  String get form_categoryLabel => 'Category';

  @override
  String get form_categoryGeneral => 'General';

  @override
  String get form_categoryCouple => 'Couple';

  @override
  String get form_categoryExam => 'Exam';

  @override
  String get form_categoryBaby => 'Baby';

  @override
  String get form_themeLabel => 'Theme';

  @override
  String get form_memoLabel => 'Memo (optional)';

  @override
  String get form_memoHint => 'Add a note...';

  @override
  String get form_save => 'Save';

  @override
  String get form_proBadge => 'PRO';

  @override
  String get error_titleRequired => 'Title is required';

  @override
  String get onboarding_title1 => 'Beautiful D-Day Cards';

  @override
  String get onboarding_desc1 =>
      'Track your important dates\nwith stunning card designs';

  @override
  String get onboarding_title2 => 'Milestone Alerts';

  @override
  String get onboarding_desc2 =>
      'Get notified when important\nmilestones are approaching';

  @override
  String get onboarding_title3 => 'Timeline View';

  @override
  String get onboarding_desc3 =>
      'See all your D-Days and\nmilestones at a glance';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_getStarted => 'Get Started';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_appearance => 'APPEARANCE';

  @override
  String get settings_themeMode => 'Theme Mode';

  @override
  String get settings_themeModeSystem => 'System';

  @override
  String get settings_themeModeLight => 'Light';

  @override
  String get settings_themeModeDark => 'Dark';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_languageEnglish => 'English';

  @override
  String get settings_languageKorean => '한국어';

  @override
  String get settings_notifications => 'NOTIFICATIONS';

  @override
  String get settings_milestoneAlerts => 'Milestone Alerts';

  @override
  String get settings_ddayAlerts => 'D-Day Alerts';

  @override
  String get settings_data => 'DATA';

  @override
  String get settings_defaultSort => 'Default Sort';

  @override
  String get settings_sortDateAsc => 'Date (Ascending)';

  @override
  String get settings_sortDateDesc => 'Date (Descending)';

  @override
  String get settings_sortCreated => 'Created';

  @override
  String get settings_sortManual => 'Manual';

  @override
  String get settings_about => 'ABOUT';

  @override
  String get settings_privacyPolicy => 'Privacy Policy';

  @override
  String get settings_termsOfService => 'Terms of Service';

  @override
  String get settings_appVersion => 'App Version';

  @override
  String get settings_restorePurchase => 'Restore Purchase';

  @override
  String get settings_proBanner => 'DayCount PRO';

  @override
  String get settings_proBannerDesc => 'Unlock all themes & features';

  @override
  String detail_daysSince(int count) {
    return '+$count days since';
  }

  @override
  String detail_daysLeft(int count) {
    return '$count days left';
  }

  @override
  String get detail_dDay => 'D-Day!';

  @override
  String get detail_months => 'months';

  @override
  String get detail_weeks => 'weeks';

  @override
  String get detail_days => 'days';

  @override
  String get detail_milestones => 'Milestones';

  @override
  String get detail_addCustom => '+ Custom';

  @override
  String get detail_reached => 'Reached ✨';

  @override
  String detail_daysRemaining(int count) {
    return 'in ${count}d';
  }

  @override
  String get detail_milestonesAfterDday => 'Milestones will appear after D-Day';

  @override
  String get detail_shareCard => 'Share Card';

  @override
  String detail_customLabel(int count) {
    return '$count Days';
  }

  @override
  String get detail_customTitle => 'Custom Milestone';

  @override
  String get detail_customHint => 'Enter days (e.g. 777)';

  @override
  String get detail_edit => 'Edit';

  @override
  String notification_milestone7d(String title, String milestone) {
    return '7 days until $title hits $milestone!';
  }

  @override
  String notification_milestone3d(String title, String milestone) {
    return 'Only 3 days to go! $title - $milestone';
  }

  @override
  String notification_milestoneToday(String title, String milestone) {
    return '🎉 Today is $milestone for $title!';
  }

  @override
  String notification_ddayToday(String title) {
    return '🎉 Today is the day! $title';
  }

  @override
  String get notification_channelName => 'Milestone Alerts';

  @override
  String get notification_channelDesc => 'Notifications for D-Day milestones';

  @override
  String get celebration_congratulations => 'Congratulations!';

  @override
  String get celebration_reached => 'reached';

  @override
  String get celebration_shareThis => 'Share This';

  @override
  String get celebration_dismiss => 'Dismiss';

  @override
  String get detail_coupleTitle => 'Couple Anniversaries';

  @override
  String detail_coupleAnniversary(int count) {
    return '$count-Day Anniversary';
  }

  @override
  String get detail_coupleNext => 'Next';

  @override
  String get detail_examTitle => 'Exam Countdown';

  @override
  String detail_examRemaining(int weeks, int days) {
    return '${weeks}w ${days}d remaining';
  }

  @override
  String get detail_examCompleted => 'Exam completed';

  @override
  String get detail_babyTitle => 'Baby Growth';

  @override
  String detail_babyAge(int months, int days) {
    return '${months}m ${days}d old';
  }

  @override
  String get detail_babyRolling => 'Rolling Over';

  @override
  String get detail_babyRollingAge => '3-4 months';

  @override
  String get detail_babySitting => 'Sitting Up';

  @override
  String get detail_babySittingAge => '6 months';

  @override
  String get detail_babyCrawling => 'Crawling';

  @override
  String get detail_babyCrawlingAge => '8-10 months';

  @override
  String get detail_babyWalking => 'Walking';

  @override
  String get detail_babyWalkingAge => '12 months';

  @override
  String get detail_proLockTitle => 'Unlock Special Mode';

  @override
  String get detail_proLockSubtitle => 'with DayCount PRO';

  @override
  String get detail_proLockButton => 'Learn More';

  @override
  String get timeline_title => 'Timeline';

  @override
  String get timeline_today => 'TODAY';

  @override
  String get share_title => 'Share Card';

  @override
  String get share_save => 'Save';

  @override
  String get share_share => 'Share';

  @override
  String get share_template => 'Template';

  @override
  String get share_saved => 'Saved to gallery!';
}
