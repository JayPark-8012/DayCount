# DayCount — 개발 태스크 목록

> 각 태스크는 Claude Code에 전달할 프롬프트와 함께 정리.
> 마일스톤 순서대로 진행. 각 마일스톤 완료 후 동작 확인 필수.

---

## M1: 프로젝트 셋업 + 핵심 CRUD (W1 전반)

### T1.1 — Flutter 프로젝트 초기화

**프롬프트:**
```
Flutter 프로젝트를 생성해줘. 프로젝트명: daycount

1. CLAUDE.md에 정의된 폴더 구조대로 디렉토리 생성
2. pubspec.yaml에 아래 패키지 추가:
   - flutter_riverpod, sqflite, path_provider, path
   - flutter_local_notifications
   - purchases_flutter
   - firebase_core, firebase_analytics, firebase_crashlytics
   - intl, share_plus, emoji_picker_flutter, google_fonts
   - dev: flutter_launcher_icons, flutter_native_splash
3. 다국어 설정 (flutter_localizations, generate: true)
4. 빈 ARB 파일 생성: lib/l10n/app_en.arb, app_ko.arb
5. main.dart에 ProviderScope 래핑
6. app.dart에 MaterialApp.router 기본 구조 (빈 홈 화면)

아직 Firebase 초기화는 하지 마. 패키지 설치와 폴더 구조만 잡아줘.
```

### T1.2 — 데이터 모델 + DB 세팅

**프롬프트:**
```
CLAUDE.md를 참고해서 데이터 레이어를 구현해줘.

1. data/models/dday.dart — DDay 모델 클래스
   - fromMap, toMap, copyWith 메서드 포함
   - CLAUDE.md의 DDay 모델 스펙 그대로

2. data/models/milestone.dart — Milestone 모델 클래스
   - notifyBefore는 JSON 문자열 ↔ List<String> 변환 포함

3. data/models/card_theme.dart — CardTheme 모델 클래스

4. data/database/database_constants.dart — 테이블명, 컬럼명 상수

5. data/database/database_helper.dart — sqflite 초기화
   - DB 이름: daycount.db
   - 버전: 1
   - onCreate: ddays, milestones, settings 3개 테이블 생성
   - 인덱스 생성 (idx_ddays_category, idx_ddays_target_date, idx_milestones_dday_id)

6. data/repositories/dday_repository.dart — CRUD
   - getAll, getById, insert, update, delete
   - delete 시 관련 milestones CASCADE 삭제

7. data/repositories/milestone_repository.dart — CRUD
   - getByDdayId, insert, insertAll, delete, deleteByDdayId

8. data/repositories/settings_repository.dart
   - get, set, getString, getBool

모든 UI 문자열은 ARB 파일에 넣어줘. 하드코딩 금지.
```

### T1.3 — Riverpod Providers 세팅

**프롬프트:**
```
Riverpod Provider들을 세팅해줘.

1. providers/dday_providers.dart
   - ddayListProvider: 전체 D-Day 리스트 (AsyncNotifierProvider)
   - CRUD 메서드: addDday, updateDday, deleteDday
   - 정렬/필터 적용된 리스트 반환

2. providers/milestone_providers.dart
   - milestonesForDdayProvider(ddayId): 특정 D-Day의 마일스톤 리스트

3. providers/settings_providers.dart
   - settingsProvider: 설정값 관리
   - themeModeProvider, languageProvider, defaultSortProvider

4. providers/filter_providers.dart
   - currentFilterProvider: 현재 필터 (all, couple, exam, baby, favorites)
   - currentSortProvider: 현재 정렬 (date_asc, date_desc, created, manual)
   - filteredDdayListProvider: 필터+정렬 적용된 리스트

Repository들을 Provider로 감싸고, UI에서는 Provider만 사용하도록 구성.
```

### T1.4 — 홈 화면 (카드형 리스트)

**프롬프트:**
```
홈 화면을 구현해줘. 기획서의 S02 와이어프레임 참고.

1. features/home/home_screen.dart
   - 앱바: 좌측 로고+DayCount 텍스트, 우측 뷰 토글 아이콘 + 설정 아이콘
   - 필터 필: 수평 스크롤, All/💕 Couple/📚 Exam/👶 Baby/⭐ Favs
   - 카드 리스트: filteredDdayListProvider 구독
   - FAB: + 버튼 (우하단)
   - D-Day 0개일 때 빈 상태 화면 (일러스트 + "Add your first D-Day!" + 버튼)

2. features/home/widgets/dday_card.dart
   - 카드별 테마 그라데이션 배경
   - 이모지 + 제목 + 날짜 + 일수 표시
   - 카운트다운: "N days left", 카운트업: "+N days ago"
   - 즐겨찾기 ⭐ 표시
   - 우측 상단 장식 원 (accent 10% opacity)
   - 탭 → 상세 화면 이동
   - fadeSlideIn 애니메이션 (stagger 80ms)

3. features/home/widgets/filter_chips.dart
4. features/home/widgets/empty_state.dart

컬러, 사이즈는 기획서 20번 디자인 가이드라인 참고.
모든 텍스트는 ARB 파일에서.
```

### T1.5 — D-Day 생성/수정 화면

**프롬프트:**
```
D-Day 생성/수정 화면을 구현해줘. 기획서 S03 참고.

1. features/dday_form/form_screen.dart
   - 수정 모드: 기존 DDay 데이터 프리필
   - 생성 모드: 빈 폼
   - 필드: 이모지 선택, 제목, 날짜 (네이티브 피커), 카테고리 (칩), 테마 선택, 메모
   - 날짜 피커: 과거/미래 모두 선택 가능, 기본값 오늘, 범위 1900~2100
   - 저장 버튼: 제목+날짜 입력 시만 활성화
   - 저장 시 마일스톤 자동 생성 (T1.6에서 구현)

2. features/dday_form/widgets/emoji_selector.dart
   - emoji_picker_flutter 패키지 사용
   - 선택된 이모지 크게 표시

3. features/dday_form/widgets/category_chips.dart
   - General, Couple, Exam, Baby — 단일 선택 칩

4. features/dday_form/widgets/theme_selector.dart
   - 컬러 서클 가로 스크롤
   - 프리미엄 테마에 🔒 PRO 뱃지
   - 잠긴 테마 탭 시 PRO 구매 화면 이동 (나중에 연결)

먼저 core/theme/card_themes.dart에 docs/design-tokens.md의 전체 테마를 정의해줘.
기본 무료 6개 + 프리미엄 15개 = 총 21개. 컬러코드는 design-tokens.md 2번 섹션 참고.
```

### T1.6 — 마일스톤 자동 생성 로직

**프롬프트:**
```
마일스톤 자동 생성 유틸을 구현해줘.

1. core/utils/milestone_generator.dart
   - generateMilestones(category, targetDate) → List<Milestone>
   - CLAUDE.md의 카테고리별 마일스톤 규칙 참고
   - 라벨 자동 생성: 365 → "1 Year", 730 → "2 Years", 100 → "100 Days" 등
   - 라벨은 ARB 파일에서 관리

2. D-Day 생성 시 자동 호출:
   - dday_providers.dart의 addDday에서 생성 후 milestoneRepository.insertAll 호출

3. 유닛 테스트:
   - test/milestone_generator_test.dart
   - 각 카테고리별 생성 결과 검증
```

### T1.7 — 온보딩 화면

**프롬프트:**
```
온보딩 화면을 구현해줘. 기획서 S01 참고.

1. features/onboarding/onboarding_screen.dart
   - 3장 PageView 슬라이드
     - 슬라이드 1: ✨ "Beautiful D-Day Cards" + 설명
     - 슬라이드 2: 🎯 "Milestone Alerts" + 설명
     - 슬라이드 3: 📊 "Timeline View" + 설명
   - 하단 dot indicator (현재 페이지 강조, 애니메이션)
   - Next 버튼 (마지막: "Get Started")
   - Skip 버튼
   - 이모지 pulse 애니메이션

2. 온보딩 완료/스킵 시:
   - settings에 onboarding_done = true 저장
   - 홈 화면으로 이동

3. app.dart에서 앱 시작 시:
   - onboarding_done 체크 → false면 온보딩, true면 홈

모든 텍스트 ARB 파일에서. 분석 이벤트: onboarding_complete (skipped: bool)
```

---

## M2: 테마 시스템 + 다크모드 (W1 후반)

### T2.1 — 앱 테마 시스템

**프롬프트:**
```
앱 전체 테마 시스템을 구현해줘.

1. core/theme/app_theme.dart
   - lightTheme, darkTheme (ThemeData)
   - 기획서 20번 컬러 시스템 적용
   - 폰트: Outfit (google_fonts 패키지)
   - 한국어 fallback: 시스템 기본 폰트

2. core/theme/theme_provider.dart
   - themeModeProvider: system / light / dark
   - settings DB와 연동

3. app.dart에서:
   - themeModeProvider 구독
   - ThemeMode 적용

다크모드 전환 시 모든 화면 정상 렌더링되는지 확인.
```

### T2.2 — 카드 테마 적용 완성

**프롬프트:**
```
카드 테마를 홈 화면 카드와 상세 화면에 완전히 적용해줘.

1. 홈 화면 카드 (dday_card.dart):
   - 카드 배경: theme.background 그라데이션
   - 텍스트: theme.textColor
   - 일수: theme.accentColor
   - 장식 원: theme.accentColor 10% opacity

2. 다크모드와 카드 테마 조합:
   - 카드 내부는 카드 테마 색상 유지
   - 카드 바깥 (배경, 앱바 등)은 앱 다크/라이트 테마 따름

3. 설정 화면에 테마 모드 선택 추가:
   - System / Light / Dark 라디오 또는 드롭다운
```

### T2.3 — 설정 화면

**프롬프트:**
```
설정 화면을 구현해줘. 기획서 S07 참고.

1. features/settings/settings_screen.dart
   - PRO 배너 (상단, 미구매 시 표시) → PRO 화면 이동
   - APPEARANCE 섹션: Theme Mode (System/Light/Dark), Language (English/한국어)
   - NOTIFICATIONS 섹션: Milestone Alerts ON/OFF, D-Day Alerts ON/OFF
   - DATA 섹션: Default Sort (Date/Created/Manual)
   - ABOUT 섹션: Privacy Policy, Terms of Service, App Version, Restore Purchase

2. 앱바에서 ⚙️ 탭 → 설정 화면 이동

3. 언어 변경 시 앱 즉시 반영 (locale 변경)
4. 테마 모드 변경 시 즉시 반영

모든 텍스트 ARB.
```

---

## M3: 마일스톤 + 알림 (W2 전반)

### T3.1 — D-Day 상세 화면

**프롬프트:**
```
D-Day 상세 화면을 구현해줘. 기획서 S04 참고.

1. features/dday_detail/detail_screen.dart
   - 상단: 테마 그라데이션 배경
     - 뒤로가기 ←, 수정 ✏️ 버튼
     - 이모지 (크게) + 제목
     - 큰 일수 (fontSize 72, ExtraBold, accentColor)
     - "days since" 또는 "days left"
     - 주/월/일 환산 카드 3개 (반투명 배경)
   - 하단: 앱 배경색 (borderRadius 상단 28)
     - "Milestones" 헤더 + "+ Custom" 버튼
     - 마일스톤 리스트
     - "Share Card" 버튼

2. features/dday_detail/widgets/counter_display.dart
3. features/dday_detail/widgets/sub_counts.dart
4. features/dday_detail/widgets/milestone_list.dart
   - 도달: ✓ + "Reached ✨" (투명도 낮춤)
   - 미도달: ○ + "N days left"
   - fadeSlideIn 애니메이션

5. 커스텀 마일스톤 추가:
   - "+ Custom" 탭 → 다이얼로그 (일수 입력) → 저장
```

### T3.2 — 로컬 알림 시스템

**프롬프트:**
```
로컬 알림 시스템을 구현해줘.

1. data/repositories/notification_repository.dart
   - flutter_local_notifications 초기화
   - scheduleNotification(id, title, body, dateTime)
   - cancelNotification(id)
   - cancelAllForDday(ddayId)
   - rescheduleAllForDday(dday, milestones)

2. 알림 ID 체계: CLAUDE.md 참고
   - ddayId * 10000 + milestoneId * 10 + notifyType

3. 알림 스케줄링 로직:
   - 마일스톤별로 7일전(type 0), 3일전(type 1), 당일(type 2) 스케줄링
   - D-Day 당일 알림도 별도 스케줄링
   - 과거 날짜 스킵
   - 시간: 오전 9:00 (로컬 타임존)

4. D-Day CRUD와 연동:
   - addDday 후 → rescheduleAllForDday 호출
   - updateDday 후 → cancelAll + rescheduleAll
   - deleteDday 후 → cancelAllForDday

5. 알림 문구: 기획서 14번 참고, ARB 파일에서 관리

6. Android/iOS 권한 설정 필요 부분 안내해줘.
```

### T3.3 — 마일스톤 축하 다이얼로그

**프롬프트:**
```
마일스톤 축하 화면을 구현해줘. 기획서 S09 참고.

1. features/milestone_celebration/celebration_dialog.dart
   - 풀스크린 다이얼로그 또는 모달 바텀시트
   - 🎉 이모지 + confetti 애니메이션
   - "Congratulations!" + D-Day 이름 + 마일스톤 이름
   - "Share This" 버튼 → 공유 카드 화면
   - "Dismiss" 버튼 → 닫기

2. 앱 시작 시 체크:
   - 오늘 도달한 마일스톤이 있는지 확인
   - 있으면 홈 화면 위에 축하 다이얼로그 표시
   - 한 번 표시한 마일스톤은 다시 표시 안 함 (settings에 기록)

3. Confetti 효과: confetti_widget 패키지 사용 (pubspec.yaml에 이미 포함)
   - 파티클 수: 50, 중력: 0.1, duration: 2초
   - 화면 상단 중앙에서 발사
```

---

## M4: 카테고리 특화 + 타임라인 (W2 후반)

### T4.1 — 카테고리별 특화 UI

**프롬프트:**
```
카테고리별 특화 기능을 구현해줘. PRO 전용 기능.

1. 커플 모드 (couple):
   - 상세 화면에서 "100일 단위 기념일 리스트" 자동 표시
   - 예: "100일: 2024-09-23", "200일: 2025-01-01" ...
   - 다음 100일 기념일까지 남은 일수 강조

2. 시험 모드 (exam):
   - 상세 화면에서 남은 주/월 크게 강조
   - "12주 3일 남음" 형태 표시

3. 육아 모드 (baby):
   - 상세 화면에서 현재 개월수 표시 ("8개월 15일")
   - 성장 마일스톤: 뒤집기(3~4개월), 앉기(6개월), 걷기(12개월) 등

4. PRO 잠금:
   - 카테고리 태그 선택은 무료
   - 특화 UI 표시 부분에 잠금 오버레이
   - "Unlock with PRO" 버튼 → PRO 구매 화면

purchaseProvider.isPro로 잠금 체크. 모든 텍스트 ARB.
```

### T4.2 — 타임라인 뷰

**프롬프트:**
```
타임라인 뷰를 구현해줘. 기획서 S05 참고.

1. features/timeline/timeline_screen.dart
   - 세로 타임라인 라인 (좌측, 그라데이션)
   - D-Day를 날짜순 정렬하여 노드로 표시
   - 각 노드: 원형 마커 + 카드 (이모지, 제목, 날짜, 일수)
   - 카드 배경: 해당 D-Day의 테마 적용

2. features/timeline/widgets/today_marker.dart
   - TODAY 마커: 강조 원 + 점선 + "TODAY" 라벨
   - 과거/미래 D-Day 사이에 위치
   - 글로우 효과

3. features/timeline/widgets/timeline_node.dart
   - 과거 이벤트: opacity 0.6, 마커 회색
   - 미래 이벤트: opacity 1.0, 마커 accent 컬러
   - 탭 → 상세 화면 이동

4. 홈 화면 뷰 토글:
   - 앱바의 📊/📋 아이콘 탭으로 리스트 ↔ 타임라인 전환
   - fade + slide 전환 애니메이션 (300ms)

5. fadeSlideIn 애니메이션 (stagger 100ms)

분석 이벤트: timeline_viewed
```

---

## M5: 공유카드 + 인앱결제 + 다국어 (W3 전반)

### T5.1 — 공유 카드 생성

**프롬프트:**
```
공유 카드 기능을 구현해줘. 기획서 S06 참고.

1. features/share_card/share_card_screen.dart
   - 앱바: ← + "Share Card"
   - 카드 미리보기: 정사각형, 테마 배경, 이모지+제목+일수+워터마크
   - 템플릿 선택: 컬러 서클 가로 스크롤 (무료 + 프리미엄 🔒)
   - 하단: "Save" + "Share" 버튼

2. features/share_card/widgets/card_preview.dart
   - RepaintBoundary로 감싸기
   - 장식 원, 그라데이션 배경, 하단 "DayCount" 워터마크

3. core/utils/share_utils.dart
   - captureWidget(globalKey) → Uint8List (PNG)
   - saveToGallery(bytes) — 갤러리 저장 (권한 요청 포함)
   - shareImage(bytes) — share_plus로 네이티브 공유 시트

4. 프리미엄 템플릿:
   - 잠금 오버레이 + PRO 뱃지
   - 탭 시 PRO 구매 화면 이동

분석 이벤트: share_card_created, share_card_shared, share_card_saved
```

### T5.2 — 인앱결제 (RevenueCat)

**프롬프트:**
```
RevenueCat 인앱결제를 구현해줘.

1. data/repositories/purchase_repository.dart
   - initPurchases() — RevenueCat 초기화
   - checkProStatus() → bool
   - purchasePro() → 구매 실행
   - restorePurchases() → 복원

2. providers/purchase_providers.dart
   - purchaseProvider: isPro 상태 관리
   - 앱 시작 시 RevenueCat 상태 동기화
   - settings DB에 is_pro 캐싱

3. features/pro_purchase/pro_screen.dart — 기획서 S08 참고
   - 다크 그라데이션 배경
   - 👑 + "DayCount PRO" + "Unlock the full experience"
   - 기능 카드 3개: Premium Themes, Special Modes, Custom Cards
   - $3.99 가격 + "One-time purchase · Forever yours"
   - "Unlock DayCount PRO" 버튼 (골드 그라데이션)
   - "Restore Purchase" 링크
   - fadeSlideIn 애니메이션

4. 잠금 체크 포인트:
   - 테마 선택 (form_screen) — 프리미엄 테마
   - 카테고리 특화 UI (detail_screen)
   - 공유 카드 커스텀 (share_card_screen) — 프리미엄 템플릿

5. RevenueCat 대시보드 설정:
   - App: daycount
   - Product: daycount_pro (Non-consumable)
   - Apple/Google 연동은 별도 안내

분석 이벤트: pro_purchase_tapped, pro_purchase_completed, pro_purchase_restored
```

### T5.3 — 다국어 완성

**프롬프트:**
```
다국어를 완성해줘.

1. 전체 앱을 훑어서 하드코딩된 텍스트가 없는지 확인
2. 누락된 문자열 모두 ARB 파일에 추가
3. app_en.arb: 영어 전체 문자열
4. app_ko.arb: 한국어 전체 문자열
5. 날짜 포맷 로케일 적용 확인 (intl 패키지)
6. 설정에서 언어 변경 시 즉시 반영 확인

특히 마일스톤 라벨, 알림 문구, 버튼 텍스트, 에러 메시지 모두 체크.
```

---

## M6: QA + 폴리싱 + 스토어 제출 (W3 후반)

### T6.1 — Firebase 연동

**프롬프트:**
```
Firebase Analytics + Crashlytics를 연동해줘.

1. Firebase 프로젝트 생성 가이드 제공 (수동으로 할 부분)
2. firebase_core 초기화 (main.dart)
3. 분석 이벤트 로깅 유틸:
   - core/utils/analytics_utils.dart
   - logEvent(name, params) 래핑
4. 기획서 15번의 모든 이벤트를 해당 위치에 삽입
5. Crashlytics: FlutterError.onError 연결
```

### T6.2 — 애니메이션 폴리싱

**프롬프트:**
```
전체 앱 애니메이션을 폴리싱해줘. 기획서 20번 참고.

1. 카드 등장: fadeSlideIn (400ms, stagger 80ms) — 이미 적용됐으면 확인만
2. 뷰 전환 (리스트↔타임라인): AnimatedSwitcher (300ms, fade+slide)
3. 마일스톤 축하: confetti 효과 (2000ms)
4. 온보딩 이모지: pulse (2000ms loop)
5. PRO 화면 왕관: shimmer/흔들림 (2000ms loop)
6. FAB: 고정, 탭 시 scale bounce (200ms)
7. 필터 칩 선택: 부드러운 색상 전환
8. 페이지 전환: 기본 Material page transition

과하지 않게, 자연스럽고 부드러운 수준으로.
```

### T6.3 — 전체 QA + 버그 수정

**프롬프트:**
```
기획서 19번 QA 체크리스트를 기준으로 전체 앱을 점검해줘.

1. flutter analyze 실행 → 경고 0개 맞추기
2. 각 영역별 체크:
   - CRUD 동작
   - 카드 UI + 테마 적용
   - 정렬/필터
   - 마일스톤 자동 생성 + 표시
   - 알림 스케줄링
   - 타임라인 뷰
   - 공유 카드
   - 인앱결제 플로우
   - 다국어
   - 다크모드
   - 엣지케이스 (0개, 100개+, 과거/미래 극단값)
3. 발견된 이슈 수정
4. 미사용 import 정리
5. TODO 잔여 확인
```

### T6.4 — 앱 아이콘 + 스플래시

**프롬프트:**
```
앱 아이콘과 스플래시 화면을 설정해줘.

1. flutter_launcher_icons 설정:
   - 아이콘 디자인: 둥근 사각형, 프라이머리 컬러(#6C63FF) → 세컨더리(#FF6B8A) 그라데이션 배경에 흰색 "D" 텍스트
   - iOS: 1024x1024
   - Android: adaptive icon

2. flutter_native_splash 설정:
   - 배경: #FAFAFA (라이트), #1A1A2E (다크)
   - 로고: 앱 아이콘 중앙

아이콘 이미지는 Flutter CustomPaint로 생성하거나,
간단한 Dart 스크립트로 PNG 생성해줘.
```

---

## 태스크 진행 시 공통 규칙

1. **각 태스크 완료 후** `flutter analyze` 실행하여 경고 0개 확인
2. **새 패키지 추가 시** 반드시 먼저 알려줘
3. **모든 UI 텍스트**는 ARB 파일에서 관리 (하드코딩 금지)
4. **기획서와 CLAUDE.md**를 항상 참고하여 스펙과 다르지 않게 구현
5. **한 태스크가 너무 크면** 자연스럽게 나눠서 진행해도 됨