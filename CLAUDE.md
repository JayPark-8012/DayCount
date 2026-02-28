# CLAUDE.md — DayCount Project

## 프로젝트 개요

- **앱 이름:** DayCount - D-Day Countdown
- **컨셉:** 예쁜 카드형 D-Day 카운터 + 마일스톤 알림
- **플랫폼:** iOS + Android (Flutter)
- **백엔드:** 없음 (순수 클라이언트 앱)
- **수익:** 광고 없음, 1회 구매 PRO ($3.99)
- **기획서:** `docs/spec.md`
- **태스크 목록:** `docs/tasks.md`

## 기술 스택

| 영역 | 스택 |
|------|------|
| Framework | Flutter (Dart) |
| Local DB | sqflite |
| State Management | flutter_riverpod |
| Notifications | flutter_local_notifications |
| In-App Purchase | RevenueCat (purchases_flutter) |
| Localization | flutter_localizations + ARB |
| Analytics | Firebase Analytics |
| Crash Report | Firebase Crashlytics |
| Image Export | RepaintBoundary → PNG |
| Confetti Effect | confetti_widget |

## 폴더 구조

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/        # app_colors, app_strings, app_config
│   ├── theme/            # app_theme, card_themes, theme_provider
│   ├── utils/            # date_utils, milestone_generator, share_utils, analytics_utils
│   └── extensions/       # datetime_ext
├── data/
│   ├── database/         # database_helper, database_constants
│   ├── models/           # dday, milestone, card_theme
│   └── repositories/     # dday, milestone, settings, purchase, notification
├── providers/            # Riverpod providers
├── features/
│   ├── home/             # home_screen + widgets/
│   ├── dday_detail/      # detail_screen + widgets/
│   ├── dday_form/        # form_screen + widgets/
│   ├── timeline/         # timeline_screen + widgets/
│   ├── share_card/       # share_card_screen + widgets/
│   ├── settings/         # settings_screen
│   ├── pro_purchase/     # pro_screen
│   ├── onboarding/       # onboarding_screen
│   └── milestone_celebration/ # celebration_dialog
└── l10n/                 # app_en.arb, app_ko.arb
```

## 코딩 컨벤션

### Dart/Flutter 스타일
- **Dart 공식 스타일 가이드** 준수
- `flutter analyze` 경고 0개 유지
- 클래스명: UpperCamelCase (`DdayCard`, `MilestoneRepository`)
- 파일명: snake_case (`dday_card.dart`, `milestone_repository.dart`)
- 상수: lowerCamelCase (`defaultThemeId`, `maxDdayCount`)
- private 멤버: `_` prefix

### 상태관리 (Riverpod)
- Provider는 `providers/` 폴더에 도메인별로 분리
- `StateNotifierProvider` 또는 `AsyncNotifierProvider` 사용
- UI에서 직접 Repository 호출 금지 → 반드시 Provider를 통해 접근
- `ref.watch`는 build 안에서만, `ref.read`는 콜백/이벤트에서 사용

### DB (sqflite)
- 테이블명, 컬럼명은 `database_constants.dart`에 상수로 정의
- SQL 쿼리는 Repository 안에서만 작성
- 모든 날짜는 ISO 8601 문자열로 저장 ("2026-03-28")

### DB 마이그레이션 규칙
- 현재 DB 버전: 1
- 마이그레이션은 `database_helper.dart`의 `onUpgrade`에서 관리
- 버전 올릴 때 switch-case로 순차 마이그레이션
- **기존 데이터 절대 삭제 금지** — ALTER TABLE ADD COLUMN만 사용
- 초기 seed 데이터: 없음 (빈 상태로 시작)

### 다국어 (ARB)
- **하드코딩 텍스트 절대 금지**
- 모든 UI 문자열은 ARB 파일에서 관리
- `AppLocalizations.of(context)!.keyName` 형태로 참조
- 새로운 문자열 추가 시 app_en.arb, app_ko.arb 동시 업데이트

### ARB 키 네이밍 컨벤션
```
// 패턴: {화면}_{요소}_{설명}
// 공통: common_{설명}
// 에러: error_{설명}
// 알림: notification_{설명}

// 예시:
home_title, home_filterAll, home_emptyTitle
detail_daysLeft, detail_milestones, detail_shareCard
form_titleHint, form_dateLabel, form_save
timeline_title, timeline_today
settings_title, settings_themeMode
pro_title, pro_unlock, pro_restore
notification_milestone7d, notification_ddayToday
common_cancel, common_delete, common_confirm
error_titleRequired, error_purchaseFailed
```

### 에러 핸들링 패턴
- **Repository**: try-catch로 예외 감싸서 throw
- **Provider**: `AsyncValue.guard()`로 에러 상태 자동 관리
- **UI**: `.when(data, loading, error)`로 3가지 상태 분기
- **사용자 액션 에러** (구매 실패, 저장 실패): SnackBar로 에러 메시지
- **치명적 에러**: Crashlytics에 자동 리포트

### 키보드 처리
- 입력 화면: `SingleChildScrollView` + `resizeToAvoidBottomInset: true`
- 빈 영역 탭 시 키보드 dismiss (`GestureDetector` + `FocusScope.unfocus()`)
- 저장 버튼이 키보드에 가려지지 않도록 스크롤 가능하게 구성

## 파일 네이밍 규칙

| 타입 | 패턴 | 예시 |
|------|------|------|
| Screen | `{feature}_screen.dart` | `home_screen.dart` |
| Widget | `{name}.dart` | `dday_card.dart` |
| Model | `{name}.dart` | `dday.dart` |
| Repository | `{name}_repository.dart` | `dday_repository.dart` |
| Provider | `{domain}_providers.dart` | `dday_providers.dart` |
| Constants | `{domain}_constants.dart` | `database_constants.dart` |
| Utils | `{name}_utils.dart` | `date_utils.dart` |

## 커밋 메시지 규칙

```
type: 간결한 설명 (영어)

feat / fix / refactor / style / chore / docs / test
```

## 테스트 규칙

- 날짜 계산 유틸: 유닛 테스트 필수
- 마일스톤 생성 로직: 유닛 테스트 필수
- Repository: 선택적
- UI/위젯: MVP에서는 수동 QA

## 금지 사항

1. **임의 패키지 추가 금지** — pubspec.yaml 변경 전 확인 요청
2. **하드코딩 텍스트 금지** — 모든 UI 문자열은 ARB
3. **직접 SQL 호출 금지** — Repository 통해서만
4. **print() 사용 금지** — `debugPrint()` 또는 `log()`
5. **임의 아키텍처 변경 금지** — 변경 전 확인 요청
6. **TODO 방치 금지** — 태스크 번호 포함
7. **미사용 import 방치 금지** — `flutter analyze` 실행
8. **기존 사용자 데이터 삭제 금지** — DB 마이그레이션 시 ADD만

## 핵심 데이터 모델

### DDay
```dart
class DDay {
  final int? id;
  final String title;
  final String targetDate;    // ISO 8601
  final String category;      // general, couple, exam, baby
  final String emoji;
  final String themeId;
  final bool isCountUp;
  final bool isFavorite;
  final String? memo;
  final bool notifyEnabled;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;
}
```

### Milestone
```dart
class Milestone {
  final int? id;
  final int ddayId;
  final int days;
  final String label;
  final bool isCustom;
  final List<String> notifyBefore; // ["7d", "3d", "0d"]
}
```

### CardTheme
```dart
class CardTheme {
  final String id;
  final String name;
  final Gradient background;
  final Color textColor;
  final Color accentColor;
  final bool isPro;
}
```

## 참고 문서

| 문서 | 내용 |
|------|------|
| `docs/spec.md` | 상세 기획서 (22개 항목) |
| `docs/tasks.md` | 개발 태스크 + Claude Code 프롬프트 |
| `docs/design-tokens.md` | 디자인 토큰 (컬러, 테마, 타이포, 애니메이션) |
| `docs/navigation.md` | 화면 네비게이션 맵 |
| `docs/date-rules.md` | 날짜 계산 규칙 |
| `docs/platform-setup.md` | 플랫폼별 설정 가이드 |
| `docs/premium-spec.md` | PRO 기능 상세 스펙 |
| `docs/store-metadata.md` | 앱스토어 메타데이터 |
