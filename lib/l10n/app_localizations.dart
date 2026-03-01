import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @common_appName.
  ///
  /// In en, this message translates to:
  /// **'DayCount'**
  String get common_appName;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'DayCount'**
  String get home_title;

  /// No description provided for @home_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get home_filterAll;

  /// No description provided for @home_filterCouple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get home_filterCouple;

  /// No description provided for @home_filterExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get home_filterExam;

  /// No description provided for @home_filterBaby.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get home_filterBaby;

  /// No description provided for @home_filterFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favs'**
  String get home_filterFavorites;

  /// No description provided for @home_daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String home_daysLeft(int count);

  /// No description provided for @home_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'+{count} days ago'**
  String home_daysAgo(int count);

  /// No description provided for @home_dDay.
  ///
  /// In en, this message translates to:
  /// **'D-Day!'**
  String get home_dDay;

  /// No description provided for @home_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first D-Day!'**
  String get home_emptyTitle;

  /// No description provided for @home_emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your important dates\nwith beautiful cards.'**
  String get home_emptySubtitle;

  /// No description provided for @home_emptyButton.
  ///
  /// In en, this message translates to:
  /// **'Create D-Day'**
  String get home_emptyButton;

  /// No description provided for @home_filterEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No D-Days found'**
  String get home_filterEmptyTitle;

  /// No description provided for @home_filterEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different filter.'**
  String get home_filterEmptySubtitle;

  /// No description provided for @home_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get home_edit;

  /// No description provided for @home_favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get home_favorite;

  /// No description provided for @home_unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get home_unfavorite;

  /// No description provided for @home_deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete D-Day?'**
  String get home_deleteConfirmTitle;

  /// No description provided for @home_deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this D-Day and all its milestones.'**
  String get home_deleteConfirmMessage;

  /// No description provided for @form_titleNew.
  ///
  /// In en, this message translates to:
  /// **'New D-Day'**
  String get form_titleNew;

  /// No description provided for @form_titleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit D-Day'**
  String get form_titleEdit;

  /// No description provided for @form_emojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get form_emojiLabel;

  /// No description provided for @form_emojiHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get form_emojiHint;

  /// No description provided for @form_titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get form_titleLabel;

  /// No description provided for @form_titleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter D-Day title'**
  String get form_titleHint;

  /// No description provided for @form_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get form_dateLabel;

  /// No description provided for @form_categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get form_categoryLabel;

  /// No description provided for @form_categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get form_categoryGeneral;

  /// No description provided for @form_categoryCouple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get form_categoryCouple;

  /// No description provided for @form_categoryExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get form_categoryExam;

  /// No description provided for @form_categoryBaby.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get form_categoryBaby;

  /// No description provided for @form_themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get form_themeLabel;

  /// No description provided for @form_memoLabel.
  ///
  /// In en, this message translates to:
  /// **'Memo (optional)'**
  String get form_memoLabel;

  /// No description provided for @form_memoHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get form_memoHint;

  /// No description provided for @form_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get form_save;

  /// No description provided for @form_proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get form_proBadge;

  /// No description provided for @error_titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get error_titleRequired;

  /// No description provided for @onboarding_title1.
  ///
  /// In en, this message translates to:
  /// **'Beautiful D-Day Cards'**
  String get onboarding_title1;

  /// No description provided for @onboarding_desc1.
  ///
  /// In en, this message translates to:
  /// **'Track your important dates\nwith stunning card designs'**
  String get onboarding_desc1;

  /// No description provided for @onboarding_title2.
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get onboarding_title2;

  /// No description provided for @onboarding_desc2.
  ///
  /// In en, this message translates to:
  /// **'Get notified when important\nmilestones are approaching'**
  String get onboarding_desc2;

  /// No description provided for @onboarding_title3.
  ///
  /// In en, this message translates to:
  /// **'Timeline View'**
  String get onboarding_title3;

  /// No description provided for @onboarding_desc3.
  ///
  /// In en, this message translates to:
  /// **'See all your D-Days and\nmilestones at a glance'**
  String get onboarding_desc3;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_getStarted;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settings_appearance;

  /// No description provided for @settings_themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settings_themeMode;

  /// No description provided for @settings_themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_themeModeSystem;

  /// No description provided for @settings_themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_themeModeLight;

  /// No description provided for @settings_themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_themeModeDark;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_languageEnglish;

  /// No description provided for @settings_languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get settings_languageKorean;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settings_notifications;

  /// No description provided for @settings_milestoneAlerts.
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get settings_milestoneAlerts;

  /// No description provided for @settings_ddayAlerts.
  ///
  /// In en, this message translates to:
  /// **'D-Day Alerts'**
  String get settings_ddayAlerts;

  /// No description provided for @settings_data.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get settings_data;

  /// No description provided for @settings_defaultSort.
  ///
  /// In en, this message translates to:
  /// **'Default Sort'**
  String get settings_defaultSort;

  /// No description provided for @settings_sortDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Date (Ascending)'**
  String get settings_sortDateAsc;

  /// No description provided for @settings_sortDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Date (Descending)'**
  String get settings_sortDateDesc;

  /// No description provided for @settings_sortCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get settings_sortCreated;

  /// No description provided for @settings_sortManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get settings_sortManual;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get settings_about;

  /// No description provided for @settings_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacyPolicy;

  /// No description provided for @settings_termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settings_termsOfService;

  /// No description provided for @settings_appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settings_appVersion;

  /// No description provided for @settings_restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get settings_restorePurchase;

  /// No description provided for @settings_proBanner.
  ///
  /// In en, this message translates to:
  /// **'DayCount PRO'**
  String get settings_proBanner;

  /// No description provided for @settings_proBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock all themes & features'**
  String get settings_proBannerDesc;

  /// No description provided for @detail_daysSince.
  ///
  /// In en, this message translates to:
  /// **'+{count} days since'**
  String detail_daysSince(int count);

  /// No description provided for @detail_daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String detail_daysLeft(int count);

  /// No description provided for @detail_dDay.
  ///
  /// In en, this message translates to:
  /// **'D-Day!'**
  String get detail_dDay;

  /// No description provided for @detail_months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get detail_months;

  /// No description provided for @detail_weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get detail_weeks;

  /// No description provided for @detail_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get detail_days;

  /// No description provided for @detail_milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get detail_milestones;

  /// No description provided for @detail_addCustom.
  ///
  /// In en, this message translates to:
  /// **'+ Custom'**
  String get detail_addCustom;

  /// No description provided for @detail_reached.
  ///
  /// In en, this message translates to:
  /// **'Reached ✨'**
  String get detail_reached;

  /// No description provided for @detail_daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'in {count}d'**
  String detail_daysRemaining(int count);

  /// No description provided for @detail_milestonesAfterDday.
  ///
  /// In en, this message translates to:
  /// **'Milestones will appear after D-Day'**
  String get detail_milestonesAfterDday;

  /// No description provided for @detail_shareCard.
  ///
  /// In en, this message translates to:
  /// **'Share Card'**
  String get detail_shareCard;

  /// No description provided for @detail_customLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String detail_customLabel(int count);

  /// No description provided for @detail_customTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Milestone'**
  String get detail_customTitle;

  /// No description provided for @detail_customHint.
  ///
  /// In en, this message translates to:
  /// **'Enter days (e.g. 777)'**
  String get detail_customHint;

  /// No description provided for @detail_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get detail_edit;

  /// No description provided for @notification_milestone7d.
  ///
  /// In en, this message translates to:
  /// **'7 days until {title} hits {milestone}!'**
  String notification_milestone7d(String title, String milestone);

  /// No description provided for @notification_milestone3d.
  ///
  /// In en, this message translates to:
  /// **'Only 3 days to go! {title} - {milestone}'**
  String notification_milestone3d(String title, String milestone);

  /// No description provided for @notification_milestoneToday.
  ///
  /// In en, this message translates to:
  /// **'🎉 Today is {milestone} for {title}!'**
  String notification_milestoneToday(String title, String milestone);

  /// No description provided for @notification_ddayToday.
  ///
  /// In en, this message translates to:
  /// **'🎉 Today is the day! {title}'**
  String notification_ddayToday(String title);

  /// No description provided for @notification_channelName.
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get notification_channelName;

  /// No description provided for @notification_channelDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications for D-Day milestones'**
  String get notification_channelDesc;

  /// No description provided for @celebration_congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get celebration_congratulations;

  /// No description provided for @celebration_reached.
  ///
  /// In en, this message translates to:
  /// **'reached'**
  String get celebration_reached;

  /// No description provided for @celebration_shareThis.
  ///
  /// In en, this message translates to:
  /// **'Share This'**
  String get celebration_shareThis;

  /// No description provided for @celebration_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get celebration_dismiss;

  /// No description provided for @detail_coupleTitle.
  ///
  /// In en, this message translates to:
  /// **'Couple Anniversaries'**
  String get detail_coupleTitle;

  /// No description provided for @detail_coupleAnniversary.
  ///
  /// In en, this message translates to:
  /// **'{count}-Day Anniversary'**
  String detail_coupleAnniversary(int count);

  /// No description provided for @detail_coupleNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get detail_coupleNext;

  /// No description provided for @detail_examTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Countdown'**
  String get detail_examTitle;

  /// No description provided for @detail_examRemaining.
  ///
  /// In en, this message translates to:
  /// **'{weeks}w {days}d remaining'**
  String detail_examRemaining(int weeks, int days);

  /// No description provided for @detail_examCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exam completed'**
  String get detail_examCompleted;

  /// No description provided for @detail_babyTitle.
  ///
  /// In en, this message translates to:
  /// **'Baby Growth'**
  String get detail_babyTitle;

  /// No description provided for @detail_babyAge.
  ///
  /// In en, this message translates to:
  /// **'{months}m {days}d old'**
  String detail_babyAge(int months, int days);

  /// No description provided for @detail_babyRolling.
  ///
  /// In en, this message translates to:
  /// **'Rolling Over'**
  String get detail_babyRolling;

  /// No description provided for @detail_babyRollingAge.
  ///
  /// In en, this message translates to:
  /// **'3-4 months'**
  String get detail_babyRollingAge;

  /// No description provided for @detail_babySitting.
  ///
  /// In en, this message translates to:
  /// **'Sitting Up'**
  String get detail_babySitting;

  /// No description provided for @detail_babySittingAge.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get detail_babySittingAge;

  /// No description provided for @detail_babyCrawling.
  ///
  /// In en, this message translates to:
  /// **'Crawling'**
  String get detail_babyCrawling;

  /// No description provided for @detail_babyCrawlingAge.
  ///
  /// In en, this message translates to:
  /// **'8-10 months'**
  String get detail_babyCrawlingAge;

  /// No description provided for @detail_babyWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get detail_babyWalking;

  /// No description provided for @detail_babyWalkingAge.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get detail_babyWalkingAge;

  /// No description provided for @detail_proLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Special Mode'**
  String get detail_proLockTitle;

  /// No description provided for @detail_proLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'with DayCount PRO'**
  String get detail_proLockSubtitle;

  /// No description provided for @detail_proLockButton.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get detail_proLockButton;

  /// No description provided for @timeline_title.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline_title;

  /// No description provided for @timeline_today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get timeline_today;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
