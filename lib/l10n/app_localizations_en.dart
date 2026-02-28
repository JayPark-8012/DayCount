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
}
