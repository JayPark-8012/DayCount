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
