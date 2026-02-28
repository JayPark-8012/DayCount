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
  String get common_save => '저장';

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

  @override
  String get form_titleNew => '새 D-Day';

  @override
  String get form_titleEdit => 'D-Day 수정';

  @override
  String get form_emojiLabel => '이모지';

  @override
  String get form_emojiHint => '탭하여 선택';

  @override
  String get form_titleLabel => '제목';

  @override
  String get form_titleHint => 'D-Day 제목을 입력하세요';

  @override
  String get form_dateLabel => '날짜';

  @override
  String get form_categoryLabel => '카테고리';

  @override
  String get form_categoryGeneral => '일반';

  @override
  String get form_categoryCouple => '커플';

  @override
  String get form_categoryExam => '시험';

  @override
  String get form_categoryBaby => '육아';

  @override
  String get form_themeLabel => '테마';

  @override
  String get form_memoLabel => '메모 (선택사항)';

  @override
  String get form_memoHint => '메모를 입력하세요...';

  @override
  String get form_save => '저장';

  @override
  String get form_proBadge => 'PRO';

  @override
  String get error_titleRequired => '제목을 입력해 주세요';

  @override
  String get onboarding_title1 => '아름다운 D-Day 카드';

  @override
  String get onboarding_desc1 => '멋진 카드 디자인으로\n소중한 날짜를 기록하세요';

  @override
  String get onboarding_title2 => '마일스톤 알림';

  @override
  String get onboarding_desc2 => '중요한 마일스톤이 다가오면\n알려드립니다';

  @override
  String get onboarding_title3 => '타임라인 뷰';

  @override
  String get onboarding_desc3 => '모든 D-Day와 마일스톤을\n한눈에 확인하세요';

  @override
  String get onboarding_next => '다음';

  @override
  String get onboarding_getStarted => '시작하기';

  @override
  String get onboarding_skip => '건너뛰기';

  @override
  String get settings_title => '설정';

  @override
  String get settings_themeMode => '테마 모드';

  @override
  String get settings_themeModeSystem => '시스템';

  @override
  String get settings_themeModeLight => '라이트';

  @override
  String get settings_themeModeDark => '다크';
}
