// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get common_appName => 'DayCount';

  @override
  String get common_cancel => '취소';

  @override
  String get common_delete => '삭제';

  @override
  String get common_confirm => '확인';

  @override
  String get home_title => 'DayCount';

  @override
  String get home_filterAll => '전체';

  @override
  String get home_filterCouple => '커플';

  @override
  String get home_filterExam => '시험';

  @override
  String get home_filterBaby => '육아';

  @override
  String get home_filterFavorites => '즐겨찾기';

  @override
  String home_daysLeft(int count) {
    return '$count일 남음';
  }

  @override
  String home_daysAgo(int count) {
    return '+$count일 지남';
  }

  @override
  String get home_dDay => 'D-Day!';

  @override
  String get home_emptyTitle => '첫 번째 D-Day를 추가하세요!';

  @override
  String get home_emptySubtitle => '아름다운 카드로\n소중한 날짜를 기록하세요.';

  @override
  String get home_emptyButton => 'D-Day 만들기';

  @override
  String get home_filterEmptyTitle => 'D-Day가 없습니다';

  @override
  String get home_filterEmptySubtitle => '다른 필터를 선택해 보세요.';
}
