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
  String get home_edit => '수정';

  @override
  String get home_favorite => '즐겨찾기';

  @override
  String get home_unfavorite => '즐겨찾기 해제';

  @override
  String get home_deleteConfirmTitle => 'D-Day를 삭제할까요?';

  @override
  String get home_deleteConfirmMessage => '이 D-Day와 모든 마일스톤이 영구적으로 삭제됩니다.';

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
  String get settings_appearance => '외관';

  @override
  String get settings_themeMode => '테마 모드';

  @override
  String get settings_themeModeSystem => '시스템';

  @override
  String get settings_themeModeLight => '라이트';

  @override
  String get settings_themeModeDark => '다크';

  @override
  String get settings_language => '언어';

  @override
  String get settings_languageEnglish => 'English';

  @override
  String get settings_languageKorean => '한국어';

  @override
  String get settings_notifications => '알림';

  @override
  String get settings_milestoneAlerts => '마일스톤 알림';

  @override
  String get settings_ddayAlerts => 'D-Day 알림';

  @override
  String get settings_data => '데이터';

  @override
  String get settings_defaultSort => '기본 정렬';

  @override
  String get settings_sortDateAsc => '날짜 (오름차순)';

  @override
  String get settings_sortDateDesc => '날짜 (내림차순)';

  @override
  String get settings_sortCreated => '생성순';

  @override
  String get settings_sortManual => '수동';

  @override
  String get settings_about => '정보';

  @override
  String get settings_privacyPolicy => '개인정보 처리방침';

  @override
  String get settings_termsOfService => '이용약관';

  @override
  String get settings_appVersion => '앱 버전';

  @override
  String get settings_restorePurchase => '구매 복원';

  @override
  String get settings_proBanner => 'DayCount PRO';

  @override
  String get settings_proBannerDesc => '모든 테마와 기능을 잠금 해제하세요';

  @override
  String detail_daysSince(int count) {
    return '+$count일 지남';
  }

  @override
  String detail_daysLeft(int count) {
    return '$count일 남음';
  }

  @override
  String get detail_dDay => 'D-Day!';

  @override
  String get detail_months => '개월';

  @override
  String get detail_weeks => '주';

  @override
  String get detail_days => '일';

  @override
  String get detail_milestones => '마일스톤';

  @override
  String get detail_addCustom => '+ 커스텀';

  @override
  String get detail_reached => '달성 ✨';

  @override
  String detail_daysRemaining(int count) {
    return '$count일 후';
  }

  @override
  String get detail_milestonesAfterDday => 'D-Day 이후 마일스톤이 표시됩니다';

  @override
  String get detail_shareCard => '카드 공유';

  @override
  String detail_customLabel(int count) {
    return '$count일';
  }

  @override
  String get detail_customTitle => '커스텀 마일스톤';

  @override
  String get detail_customHint => '일수를 입력하세요 (예: 777)';

  @override
  String get detail_edit => '수정';

  @override
  String notification_milestone7d(String title, String milestone) {
    return '$title $milestone까지 7일!';
  }

  @override
  String notification_milestone3d(String title, String milestone) {
    return '$title $milestone까지 3일!';
  }

  @override
  String notification_milestoneToday(String title, String milestone) {
    return '🎉 오늘은 $title $milestone이에요!';
  }

  @override
  String notification_ddayToday(String title) {
    return '🎉 오늘이에요! $title';
  }

  @override
  String get notification_channelName => '마일스톤 알림';

  @override
  String get notification_channelDesc => 'D-Day 마일스톤 알림';

  @override
  String get celebration_congratulations => '축하합니다!';

  @override
  String get celebration_reached => '달성';

  @override
  String get celebration_shareThis => '공유하기';

  @override
  String get celebration_dismiss => '닫기';

  @override
  String get detail_coupleTitle => '커플 기념일';

  @override
  String detail_coupleAnniversary(int count) {
    return '$count일 기념일';
  }

  @override
  String get detail_coupleNext => '다음';

  @override
  String get detail_examTitle => '시험 카운트다운';

  @override
  String detail_examRemaining(int weeks, int days) {
    return '$weeks주 $days일 남음';
  }

  @override
  String get detail_examCompleted => '시험 완료';

  @override
  String get detail_babyTitle => '아기 성장';

  @override
  String detail_babyAge(int months, int days) {
    return '$months개월 $days일';
  }

  @override
  String get detail_babyRolling => '뒤집기';

  @override
  String get detail_babyRollingAge => '3-4개월';

  @override
  String get detail_babySitting => '앉기';

  @override
  String get detail_babySittingAge => '6개월';

  @override
  String get detail_babyCrawling => '기어가기';

  @override
  String get detail_babyCrawlingAge => '8-10개월';

  @override
  String get detail_babyWalking => '걷기';

  @override
  String get detail_babyWalkingAge => '12개월';

  @override
  String get detail_proLockTitle => '스페셜 모드 잠금 해제';

  @override
  String get detail_proLockSubtitle => 'DayCount PRO로';

  @override
  String get detail_proLockButton => '자세히 보기';

  @override
  String get timeline_title => '타임라인';

  @override
  String get timeline_today => 'TODAY';
}
