# QA List — DayCount 기획서 vs 구현 대조

> 작성일: 2026-02-28
> 기준: docs/spec.md, docs/date-rules.md, docs/navigation.md, docs/design-tokens.md

---

## 1. 구현 완료 기능 (Spec 일치)

| # | 기능 | 기획서 | 상태 |
|---|------|--------|------|
| 1 | 온보딩 3슬라이드 (S01) | PageView + dot indicator + Skip/Next/GetStarted | OK |
| 2 | 이모지 pulse 애니메이션 | 1→1.08→1, 2000ms, easeInOut, infinite | OK |
| 3 | 온보딩 완료 후 홈 이동 | onboarding_done settings 저장 | OK |
| 4 | 홈 카드 리스트 (S02) | 테마 그라데이션, 이모지, 제목, 날짜, 카운트 | OK |
| 5 | 필터 칩 | All/Couple/Exam/Baby/Favorites 5개 | OK |
| 6 | 빈 상태 2종 | 전체 빈 상태 + 필터 빈 상태 | OK |
| 7 | FAB + 버튼 | gradient + 그림자, 새 D-Day 생성 | OK |
| 8 | 카드 fadeSlideIn 애니메이션 | 400ms, stagger 80ms | OK |
| 9 | 생성/수정 폼 (S03) | 이모지/제목/날짜/카테고리/테마/메모 | OK |
| 10 | 날짜 범위 | 1900~2100 | OK |
| 11 | 테마 선택기 21종 | 6 free + 15 premium (PRO 배지) | OK |
| 12 | 저장 버튼 validation | 제목 필수, 비어있으면 disabled | OK |
| 13 | 상세 화면 (S04) | 그라데이션 헤더 + 카운터 + 서브카운트 + 마일스톤 | OK |
| 14 | 대형 숫자 72pt | counter_display.dart ExtraBold 800 | OK |
| 15 | 서브카운트 3카드 | months(÷30), weeks(÷7), days | OK |
| 16 | 마일스톤 리스트 | 달성(✓ + "Reached ✨") / 미달성(○ + "in Nd") | OK |
| 17 | 커스텀 마일스톤 추가 | "+ Custom" 버튼 + 숫자 입력 다이얼로그 | OK |
| 18 | 커스텀 입력 검증 | 0 이하 값 거부 (digits only) | OK |
| 19 | 마일스톤 자동 생성 | general/couple/exam/baby 카테고리별 규칙 | OK |
| 20 | 로컬 알림 시스템 (N01-N04) | 7d/3d/당일 + D-Day 당일, 오전 9시 | OK |
| 21 | 알림 ID 체계 | ddayId*10000 + milestoneId*10 + notifyType | OK |
| 22 | CRUD + 알림 연동 | add→스케줄, update→재스케줄, delete→취소 | OK |
| 23 | 마일스톤 축하 다이얼로그 (S09) | confetti + 🎉 + 축하 메시지 + Share/Dismiss | OK |
| 24 | 축하 중복 방지 | settings에 celebrated_ 키 기록 | OK |
| 25 | 설정 화면 (S07) | 테마모드/언어/알림토글/정렬/앱정보 | OK |
| 26 | 다크/라이트 모드 | System/Light/Dark 3단 전환 | OK |
| 27 | 다국어 EN/KO | 모든 UI 문자열 ARB, 즉시 전환 | OK |
| 28 | Android 알림 권한 | POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED | OK |
| 29 | DB 스키마 | ddays(14) + milestones(6) + settings(2) 테이블 + 인덱스 | OK |
| 30 | Exam 카테고리 날짜 계산 | subtract (D-Day까지 남은 일수) | OK |
| 31 | 상세 화면 카운터 방향 | target.difference(today) — 미래=양수, 과거=음수 | OK |
| 32 | 마일스톤 미래 날짜 숨김 | 비-exam 미래 D-Day에서 마일스톤 섹션 숨김 + 안내 메시지 | OK |
| 33 | 홈 카드 롱프레스 메뉴 | Edit/Favorite/Delete ModalBottomSheet | OK |
| 34 | 삭제 확인 다이얼로그 | AlertDialog (취소/삭제) | OK |
| 35 | isCountUp 자동 판정 | 폼 저장 시 targetDate.isBefore(today) 체크 | OK |
| 36 | dateAsc 미래 우선 정렬 | 가까운 미래 → 먼 미래 → 최근 과거 → 먼 과거 | OK |
| 37 | 알림 글로벌 토글 연동 | Settings의 milestone/dday alerts → rescheduleAllForDday 반영 | OK |
| 38 | 커스텀 마일스톤 다국어 라벨 | l10n.detail_customLabel(days) 사용 | OK |

---

## 2. 기획서와 다른 부분 (수정 필요)

### ~~2.1 dateAsc 정렬 로직 불일치 [P0]~~ ✅ 수정 완료
- 미래 우선 정렬 구현 (`filter_providers.dart`)

### ~~2.2 isCountUp 자동 판정 누락 [P1]~~ ✅ 수정 완료
- 폼 저장 시 `targetDate.isBefore(today)` 자동 판정 추가

### ~~2.3 홈 카드 롱프레스 컨텍스트 메뉴 미구현 [P1]~~ ✅ 수정 완료
- ModalBottomSheet (Edit/Favorite/Delete) 구현

### ~~2.4 삭제 확인 다이얼로그 미구현 [P1]~~ ✅ 수정 완료
- AlertDialog (취소/삭제) 구현

### 2.5 폼 뒤로가기 시 변경사항 확인 다이얼로그 미구현 [P2]
- **기획서 (navigation.md):** "Discard changes?" 다이얼로그 (Discard / Keep Editing)
- **현재 구현:** 뒤로가기 시 바로 팝 (변경사항 경고 없음)
- **위치:** `lib/features/dday_form/form_screen.dart`

### ~~2.6 Settings 알림 토글이 실제 알림 스케줄링에 반영 안 됨 [P1]~~ ✅ 수정 완료
- `rescheduleAllForDday`에 `milestoneAlertsEnabled`/`ddayAlertsEnabled` 파라미터 추가

### 2.7 알림 탭 시 상세 화면 딥링크 미구현 [P2]
- **기획서 (navigation.md):** "Tap notification → App opens → navigate to S04 (detail screen)"
- **현재 구현:** `_onNotificationTapped`에서 debugPrint만 (네비게이션 없음)
- **위치:** `lib/data/repositories/notification_repository.dart:66-70`

### 2.8 Baby 카테고리 월 계산 — 30일 고정 나누기 [P2]
- **기획서 (date-rules.md):** Baby는 정확한 달력 기반 월 계산 (`monthsSince` + `remainingDays`)
- **현재 구현:** 모든 카테고리 동일하게 `totalDays ÷ 30` 근사치 사용
- **위치:** `lib/features/dday_detail/widgets/sub_counts.dart:21`

### ~~2.9 커스텀 마일스톤 라벨 하드코딩 [P2]~~ ✅ 수정 완료
- `l10n.detail_customLabel(days)` 사용으로 변경

---

## 3. 미구현 기능 (TODO)

### 3.1 화면 미구현

| # | 화면 | 기획서 | 상태 | 우선순위 |
|---|------|--------|------|----------|
| 1 | 타임라인 뷰 (S05) | 수직 그라데이션 라인 + TODAY 마커 + 날짜 정렬 노드 | 미구현 | P2 |
| 2 | 공유 카드 화면 (S06) | 1:1 카드 프리뷰 + 템플릿 선택 + Save/Share | 미구현 | P2 |
| 3 | PRO 구매 화면 (S08) | 👑 + 기능 카드 3개 + $3.99 + RevenueCat | 미구현 | P1 |

### 3.2 기능 미구현

| # | 기능 | 기획서 참조 | 상태 | 우선순위 |
|---|------|------------|------|----------|
| 4 | Firebase Analytics 초기화 | spec.md 15번 (21개 이벤트) | 미구현 (import만 존재) | P1 |
| 5 | Firebase Crashlytics 초기화 | spec.md 기술스택 | 미구현 | P1 |
| 6 | PRO 테마 탭 시 구매 화면 이동 | S03, navigation.md | TODO(T-pro) | P1 |
| 7 | 카테고리 특화 UI (F10) | spec.md F10 (PRO 기능) | 미구현 | P2 |
| 8 | 개인정보 처리방침 링크 | S07 | TODO(T-about) | P2 |
| 9 | 이용약관 링크 | S07 | TODO(T-about) | P2 |
| 10 | 구매 복원 기능 | S07, S08 | TODO(T-pro) | P1 |

### 3.3 TODO 목록 (코드에 남아있는 TODO)

| 위치 | TODO 태그 | 내용 |
|------|----------|------|
| `home_screen.dart:141` | TODO(T11) | Navigate to timeline view |
| `home_screen.dart:67` | TODO(T-share) | Navigate to share card screen (celebration) |
| `detail_screen.dart:170` | TODO(T-share) | Navigate to share card screen |
| `theme_selector.dart:54` | TODO(T-pro) | PRO theme tap → purchase screen |
| `settings_screen.dart:66` | TODO(T-pro) | PRO banner tap |
| `settings_screen.dart:180` | TODO(T-about) | Privacy Policy link |
| `settings_screen.dart:189` | TODO(T-about) | Terms of Service link |
| `settings_screen.dart:205` | TODO(T-pro) | Restore purchase |
| `onboarding_screen.dart:167` | TODO(T-analytics) | Log onboarding completion event |

---

## 4. 기타 점검 사항

### 4.1 잠재적 이슈

| # | 이슈 | 설명 | 심각도 |
|---|------|------|--------|
| 1 | confetti 패키지명 불일치 | CLAUDE.md에 `confetti_widget`으로 명시되어 있으나, 실제 설치된 패키지는 `confetti: ^0.8.0` (정상 동작) | Low |
| 2 | Notification ID 범위 제한 | ddayId * 10000 — ddayId가 214748 이상이면 int overflow 가능 (실사용에서는 문제 없음) | Low |
| 3 | 유닛 테스트 부재 | milestone_generator, date 계산 유틸에 대한 유닛 테스트 없음 (spec에서는 "필수"로 명시) | Medium |
| 4 | Web에서 알림 미지원 | kIsWeb 체크로 알림 스킵 — 웹에서 알림 관련 UI(설정 토글 등)는 표시되지만 동작 안 함 | Low |

### 4.2 디자인 토큰 대조

| 항목 | 기획서 | 구현 | 일치 |
|------|--------|------|------|
| 카드 Radius | 20px | 20px (cardRadius) | OK |
| 마일스톤 Radius | 14px | 14px (milestoneCardRadius) | OK |
| FAB Radius | 18px | 18px (fabRadius) | OK |
| Button Radius | 16px | 16px (buttonRadius) | OK |
| 카드 장식 원 | top-right -20/-20, 100x100, accent 10% | 구현됨 | OK |
| FAB 그림자 | 0 8px 24px rgba(primary, 0.4) | 구현됨 | OK |
| Font | Outfit (google_fonts) | 적용됨 | OK |
| 큰 숫자 fontSize | 72pt (상세), 36pt (카드) | 72pt/36pt | OK |
| 서브카운트 fontSize | 22pt | 22pt | OK |

---

## 5. 수정 우선순위 요약

### P0 (반드시 수정)
1. dateAsc 정렬 로직 — 미래 우선 정렬 구현

### P1 (주요 기능)
2. isCountUp 자동 판정 (과거 날짜 → countUp)
3. 홈 카드 롱프레스 컨텍스트 메뉴 (Edit/Favorite/Delete)
4. 삭제 확인 다이얼로그
5. Settings 알림 토글 → 실제 알림 반영

### P2 (부가 기능)
6. 폼 뒤로가기 변경사항 확인 다이얼로그
7. 알림 딥링크 (탭 → 상세 화면)
8. Baby 카테고리 정확한 월 계산
9. 커스텀 마일스톤 라벨 다국어화
