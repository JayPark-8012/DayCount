# DayCount - D-Day Countdown | 상세 기획서

> **Version:** 1.0
> **Last Updated:** 2026-02-28
> **Status:** MVP 개발 준비 완료

---

## 1. 프로젝트 정의

| 항목 | 내용 |
|------|------|
| **앱 이름** | DayCount - D-Day Countdown |
| **핵심 컨셉** | 예쁜 카드형 D-Day 카운터 + 마일스톤 알림 |
| **타겟 유저** | 글로벌(영어) 1순위, 한국어 2순위 — 20~30대 여성 중심, 수험생/취준생, 신혼/육아 |
| **플랫폼** | iOS (App Store) + Android (Google Play) |
| **수익 모델** | 광고 없음, 1회 구매 PRO ($3.99 / ₩4,900) |
| **카테고리** | Lifestyle (primary), Utilities (secondary) |

---

## 2. 핵심 차별점

1. **감성 카드형 UI** — 캡처해서 SNS에 공유하고 싶은 디자인
2. **마일스톤 자동 생성 + 사전 알림** — 100일, 200일, 1주년 등 자동 + 7일전/3일전/당일 알림
3. **카테고리별 특화 모드** — 커플(100일 단위), 시험(남은 주/월), 육아(개월수/성장 마일스톤)
4. **타임라인 뷰** — 내 인생 이벤트를 시간 축 위에 한눈에
5. **계정 강제 없음** — 로컬 우선, 가입 없이 즉시 사용

---

## 3. 기능 목록

| ID | 기능 | 무료/유료 | 우선순위 | 설명 |
|----|------|----------|----------|------|
| F01 | D-Day 생성/수정/삭제 | 무료 | P0 | 이름, 날짜, 카테고리, 이모지, 테마, 메모 |
| F02 | 카드형 리스트 뷰 | 무료 | P0 | 홈 화면 메인 뷰, 카드별 테마 적용 |
| F03 | D-Day 상세 화면 | 무료 | P0 | 남은/지난 일수, 주/월 환산, 마일스톤 리스트, 공유 버튼 |
| F04 | 카테고리 태그 | 무료 | P0 | 일반/커플/시험/육아 분류 |
| F05 | 기본 테마 (6개) | 무료 | P1 | Cloud, Sunset, Ocean, Forest, Lavender, Minimal |
| F06 | 프리미엄 테마 (10~15개) | 유료 | P1 | Midnight, Cherry, Aurora, Peach, Noir 등 |
| F07 | 마일스톤 자동 생성 | 무료 | P1 | 카테고리별 자동: 일반(100/200/365일), 커플(100일 단위), 육아(개월수) |
| F08 | 마일스톤 사전 알림 | 무료 | P1 | 7일전, 3일전, 당일 로컬 알림. D-Day별 ON/OFF (기본 ON) |
| F09 | 커스텀 마일스톤 추가 | 무료 | P1 | 유저가 원하는 일수 직접 추가 (예: 777일) |
| F10 | 카테고리별 특화 UI/계산 | 유료 | P2 | 커플: 100일 단위 자동 리스트, 육아: 개월수+성장 마일스톤, 시험: 남은 주/월 강조 |
| F11 | 타임라인 뷰 | 무료 | P2 | 시간 축 위에 모든 D-Day 시각적 배치, TODAY 마커 |
| F12 | 공유 카드 이미지 생성 (기본) | 무료 | P2 | 기본 템플릿으로 이미지 생성, 갤러리 저장/SNS 공유 |
| F13 | 공유 카드 커스텀 | 유료 | P2 | 프리미엄 템플릿, 폰트, 컬러 선택 |
| F14 | 인앱결제 (1회 구매 PRO) | - | P1 | Non-consumable, RevenueCat 연동, 구매 복원 지원 |
| F15 | 로컬 알림 | 무료 | P1 | flutter_local_notifications, 마일스톤 + D-Day 당일 알림 |
| F16 | 다국어 (영어/한국어) | 무료 | P0 | ARB 파일 기반, 하드코딩 텍스트 금지 |
| F17 | 정렬/필터 | 무료 | P1 | 날짜순, 카테고리별, 즐겨찾기 필터 |
| F18 | 다크모드 | 무료 | P1 | 시스템 설정 연동 + 수동 전환 |
| F19 | 온보딩 화면 | 무료 | P0 | 3장 슬라이드 (카드 소개, 마일스톤, 타임라인), Skip 가능 |

---

## 4. 화면 목록 + 화면별 와이어프레임

### S01: 온보딩

```
┌─────────────────────────┐
│       [Status Bar]       │
│                          │
│                          │
│           ✨              │
│    (큰 이모지 애니메이션)   │
│                          │
│   Beautiful D-Day Cards  │
│   Track your important   │
│   dates with stunning    │
│   card designs           │
│                          │
│       ● ○ ○              │
│                          │
│   ┌─────────────────┐    │
│   │      Next       │    │
│   └─────────────────┘    │
│         Skip             │
└─────────────────────────┘
```

- 3장 슬라이드: 카드 소개 → 마일스톤 알림 → 타임라인 뷰
- 마지막 슬라이드 "Get Started" 버튼
- Skip 버튼으로 건너뛰기 가능

### S02: 홈 (리스트 뷰)

```
┌─────────────────────────┐
│       [Status Bar]       │
│ [D] DayCount    📊  ⚙️  │
│                          │
│ [All] [💕Couple] [📚Exam]│
│                          │
│ ┌───────────────────┐    │
│ │ 💕 Our Anniversary │    │
│ │ 2024-06-15        +624 │
│ │                days ago│
│ └───────────────────┘    │
│ ┌───────────────────┐    │
│ │ 📚 Final Exam      │    │
│ │ 2026-06-20         112 │
│ │               days left│
│ └───────────────────┘    │
│ ┌───────────────────┐    │
│ │ 👶 Baby's Birthday  │    │
│ │ 2025-09-10        +171 │
│ │                days ago│
│ └───────────────────┘    │
│                    [+]   │
└─────────────────────────┘
```

- 앱바: 로고 + 뷰 토글(📋↔📊) + 설정(⚙️)
- 필터 필: All, 💕 Couple, 📚 Exam, 👶 Baby, ⭐ Favs
- 카드: 이모지 + 제목 + 날짜 + 일수 표시 (테마별 그라데이션 배경)
- FAB: + 새 D-Day 추가

### S03: D-Day 생성/수정

```
┌─────────────────────────┐
│       [Status Bar]       │
│ ← New D-Day              │
│                          │
│ Emoji:  [💕] (탭하여 선택) │
│                          │
│ Title:                   │
│ ┌───────────────────┐    │
│ │ Our Anniversary    │    │
│ └───────────────────┘    │
│                          │
│ Date:                    │
│ ┌───────────────────┐    │
│ │ 2024-06-15    📅   │    │
│ └───────────────────┘    │
│                          │
│ Category:                │
│ [General] [Couple✓] [Exam]│
│ [Baby]                   │
│                          │
│ Theme:                   │
│ [○Cloud] [○Sunset] [●Lav]│
│ [🔒Midnight] [🔒Cherry]  │
│                          │
│ Memo (optional):         │
│ ┌───────────────────┐    │
│ │                    │    │
│ └───────────────────┘    │
│                          │
│ ┌─────────────────┐      │
│ │      Save       │      │
│ └─────────────────┘      │
└─────────────────────────┘
```

- 이모지 선택: 이모지 피커
- 날짜: 네이티브 날짜 피커
- 카테고리: 칩 선택 (단일 선택)
- 테마: 컬러 서클 선택, 프리미엄은 🔒 + PRO 뱃지
- 잠긴 테마 탭 시 PRO 구매 화면 이동

### S04: D-Day 상세

```
┌─────────────────────────┐
│       [Status Bar]       │
│ ←                    ✏️  │
│    (테마 그라데이션 배경)   │
│           💕              │
│    Our Anniversary       │
│                          │
│         +624             │
│        days since        │
│                          │
│  ┌──────┐┌──────┐┌──────┐│
│  │  20  ││  89  ││ 624  ││
│  │months││weeks ││ days ││
│  └──────┘└──────┘└──────┘│
│                          │
│ ┌───────────────────────┐│
│ │ Milestones    + Custom ││
│ │                        ││
│ │ ✓ 100 Days   Reached ✨││
│ │ ✓ 200 Days   Reached ✨││
│ │ ✓ 365 Days   Reached ✨││
│ │ ✓ 500 Days   Reached ✨││
│ │ ○ 600 Days   in 76d   ││
│ │ ○ 730 Days   in 106d  ││
│ │ ○ 1000 Days  in 376d  ││
│ │                        ││
│ │ ┌──────────────────┐   ││
│ │ │  📤 Share Card   │   ││
│ │ └──────────────────┘   ││
│ └───────────────────────┘│
└─────────────────────────┘
```

- 상단: 테마 배경 + 이모지 + 제목 + 큰 일수 + 주/월 환산 카드
- 하단: 마일스톤 리스트 (도달=체크+✨, 미도달=남은 일수)
- "Share Card" 버튼 → S06으로 이동
- "Custom" 버튼 → 커스텀 마일스톤 추가 (일수 입력)

### S05: 타임라인 뷰

```
┌─────────────────────────┐
│       [Status Bar]       │
│ [D] Timeline        📋   │
│                          │
│  ● 💕 Our Anniversary    │
│  │  2024-06-15    +624   │
│  │                       │
│  ● 👶 Baby's Birthday    │
│  │  2025-09-10    +171   │
│  │                       │
│  ◉ ── TODAY ──────────── │
│  │                       │
│  ● 🚀 Project Launch     │
│  │  2026-03-30      30   │
│  │                       │
│  ● ✈️ Trip to Tokyo      │
│  │  2026-04-15      46   │
│  │                       │
│  ● 📚 Final Exam         │
│     2026-06-20     112   │
│                          │
└─────────────────────────┘
```

- 세로 타임라인 라인 + 노드
- TODAY 마커 (강조 색상 + 글로우)
- 과거 이벤트: 약간 투명도 낮춤
- 카드 탭 → S04 상세 화면으로 이동

### S06: 공유 카드 생성

```
┌─────────────────────────┐
│       [Status Bar]       │
│ ←    Share Card          │
│                          │
│  ┌───────────────────┐   │
│  │                   │   │
│  │       💕          │   │
│  │  Our Anniversary  │   │
│  │                   │   │
│  │      +624         │   │
│  │   days together   │   │
│  │                   │   │
│  │          DayCount │   │
│  └───────────────────┘   │
│                          │
│  Template:               │
│  [○] [○] [○] [○] [🔒]   │
│                          │
│  ┌────────┐ ┌────────┐   │
│  │💾 Save │ │📤 Share│   │
│  └────────┘ └────────┘   │
└─────────────────────────┘
```

- 카드 미리보기: 정사각형 비율, 테마 배경 + 이모지 + 제목 + 일수
- 템플릿 선택: 컬러 서클 (무료 + 프리미엄 🔒)
- 프리미엄 템플릿 탭 시 PRO 구매 유도
- Save: 갤러리에 이미지 저장
- Share: 네이티브 공유 시트 (카카오, 인스타, 기타)

### S07: 설정

```
┌─────────────────────────┐
│       [Status Bar]       │
│ Settings                 │
│                          │
│ ┌───────────────────────┐│
│ │ 👑 DayCount PRO       ││
│ │ Unlock all themes &   ││
│ │ features              ││
│ └───────────────────────┘│
│                          │
│ APPEARANCE               │
│ ┌───────────────────────┐│
│ │ Theme Mode   [System▾]││
│ │ Language     [English▾]││
│ └───────────────────────┘│
│                          │
│ NOTIFICATIONS            │
│ ┌───────────────────────┐│
│ │ Milestone Alerts  [ON]││
│ │ D-Day Alerts      [ON]││
│ └───────────────────────┘│
│                          │
│ DATA                     │
│ ┌───────────────────────┐│
│ │ Default Sort [Date ▾] ││
│ └───────────────────────┘│
│                          │
│ ABOUT                    │
│ ┌───────────────────────┐│
│ │ Privacy Policy        ││
│ │ Terms of Service      ││
│ │ App Version    v1.0.0 ││
│ │ Restore Purchase      ││
│ └───────────────────────┘│
└─────────────────────────┘
```

### S08: PRO 구매

```
┌─────────────────────────┐
│       [Status Bar]       │
│ ←                        │
│     (다크 그라데이션 배경)  │
│           👑              │
│      DayCount PRO        │
│  Unlock the full experience│
│                          │
│  ┌───────────────────┐   │
│  │ 🎨 Premium Themes │   │
│  │ 15+ stunning card  │   │
│  │ themes             │   │
│  └───────────────────┘   │
│  ┌───────────────────┐   │
│  │ 💕 Special Modes   │   │
│  │ Couple, exam &     │   │
│  │ baby trackers      │   │
│  └───────────────────┘   │
│  ┌───────────────────┐   │
│  │ 📤 Custom Cards    │   │
│  │ Premium templates  │   │
│  │ & fonts            │   │
│  └───────────────────┘   │
│                          │
│         $3.99            │
│  One-time purchase       │
│  Forever yours           │
│                          │
│  ┌──────────────────┐    │
│  │ Unlock DayCount  │    │
│  │      PRO         │    │
│  └──────────────────┘    │
│    Restore Purchase      │
└─────────────────────────┘
```

### S09: 마일스톤 축하 화면

```
┌─────────────────────────┐
│       [Status Bar]       │
│                          │
│     🎊 (confetti 효과)   │
│                          │
│          🎉              │
│                          │
│    Congratulations!      │
│                          │
│   💕 Our Anniversary     │
│     reached             │
│       500 Days!          │
│                          │
│                          │
│   ┌──────────────────┐   │
│   │  📤 Share This   │   │
│   └──────────────────┘   │
│   ┌──────────────────┐   │
│   │     Dismiss      │   │
│   └──────────────────┘   │
└─────────────────────────┘
```

- 알림 탭 시 또는 앱 열었을 때 마일스톤 도달 감지 시 표시
- Confetti 애니메이션
- 공유 버튼 → S06으로 이동
- Dismiss → 홈으로 복귀

---

## 5. 유저 플로우

### Flow 1: 첫 실행
```
앱 설치 → S01 온보딩 (3장) → S02 홈 (빈 상태) → FAB 탭 → S03 생성 → 저장 → S02 홈 (카드 1개 표시)
```

### Flow 2: D-Day 확인 & 마일스톤
```
S02 홈 → 카드 탭 → S04 상세 → 마일스톤 리스트 확인 → 커스텀 마일스톤 추가 가능
```

### Flow 3: 공유 카드 생성
```
S04 상세 → "Share Card" 탭 → S06 공유 카드 → 템플릿 선택 → "Save" (갤러리) 또는 "Share" (SNS)
```

### Flow 4: PRO 구매
```
S07 설정 PRO 배너 탭 → S08 PRO 구매 → 결제 → 잠금 해제 → 설정으로 복귀
또는
S03 생성에서 잠긴 테마 탭 → S08 PRO 구매 → 결제 → 잠금 해제 → 생성 화면 복귀
```

### Flow 5: 타임라인 확인
```
S02 홈 → 앱바 뷰 토글(📊) 탭 → S05 타임라인 → D-Day 노드 탭 → S04 상세
```

---

## 6. 예외 처리 정의

| 상황 | 처리 |
|------|------|
| **알림 권한 거부** | 설정 화면에 "알림이 꺼져 있습니다" 배너 표시 + 시스템 설정으로 이동 버튼 |
| **인앱결제 실패** | 에러 메시지 + 재시도 버튼 + "문제 지속 시 앱 재시작" 안내 |
| **인앱결제 복원 실패** | "구매 내역이 없습니다" 또는 "네트워크 연결을 확인하세요" 메시지 |
| **날짜 미선택으로 저장** | 저장 버튼 비활성화 + 날짜 필드 하이라이트 |
| **제목 미입력으로 저장** | 저장 버튼 비활성화 + 제목 필드 하이라이트 |
| **D-Day 삭제** | "정말 삭제하시겠습니까? 관련 마일스톤과 알림도 함께 삭제됩니다" 확인 다이얼로그 |
| **오프라인 상태** | 로컬 앱이라 영향 없음. 인앱결제 시에만 "인터넷 연결을 확인하세요" 표시 |
| **이미지 저장 권한 거부** | "갤러리 접근 권한이 필요합니다" + 설정 이동 버튼 |
| **D-Day 0개 (빈 상태)** | 일러스트 + "Add your first D-Day!" 안내 + 생성 버튼 |
| **앱 업데이트 후 데이터** | sqflite 마이그레이션으로 기존 데이터 보존 |

---

## 7. 데이터 설계

### 로컬 DB: sqflite

**테이블 1: ddays**

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INTEGER PK AUTOINCREMENT | 자동 증가 |
| title | TEXT NOT NULL | D-Day 이름 |
| target_date | TEXT NOT NULL | 목표 날짜 (ISO 8601: "2026-03-28") |
| category | TEXT NOT NULL DEFAULT 'general' | general / couple / exam / baby |
| emoji | TEXT NOT NULL DEFAULT '📅' | 이모지 아이콘 |
| theme_id | TEXT NOT NULL DEFAULT 'cloud' | 적용된 테마 ID |
| is_count_up | INTEGER NOT NULL DEFAULT 0 | 0=카운트다운, 1=카운트업 (target_date가 과거면 자동 전환) |
| is_favorite | INTEGER NOT NULL DEFAULT 0 | 즐겨찾기 여부 |
| memo | TEXT | 메모 (선택) |
| notify_enabled | INTEGER NOT NULL DEFAULT 1 | 알림 ON/OFF |
| sort_order | INTEGER NOT NULL DEFAULT 0 | 수동 정렬 순서 |
| created_at | TEXT NOT NULL | 생성일 (ISO 8601) |
| updated_at | TEXT NOT NULL | 수정일 (ISO 8601) |

**테이블 2: milestones**

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INTEGER PK AUTOINCREMENT | 자동 증가 |
| dday_id | INTEGER NOT NULL | ddays.id FK (CASCADE DELETE) |
| days | INTEGER NOT NULL | 마일스톤 일수 (100, 200, 365 등) |
| label | TEXT NOT NULL | 표시명 ("100 Days", "1 Year") |
| is_custom | INTEGER NOT NULL DEFAULT 0 | 0=자동생성, 1=유저 커스텀 |
| notify_before | TEXT NOT NULL DEFAULT '["7d","3d","0d"]' | 알림 타이밍 JSON |

**테이블 3: settings**

| 컬럼 | 타입 | 설명 |
|------|------|------|
| key | TEXT PK | 설정 키 |
| value | TEXT | 설정 값 |

settings 키 목록:
- `theme_mode`: "system" / "light" / "dark"
- `language`: "en" / "ko"
- `default_sort`: "date_asc" / "date_desc" / "created" / "manual"
- `onboarding_done`: "true" / "false"
- `is_pro`: "true" / "false" (RevenueCat과 동기화)

**인덱스:**
- `idx_ddays_category` ON ddays(category)
- `idx_ddays_target_date` ON ddays(target_date)
- `idx_milestones_dday_id` ON milestones(dday_id)

---

## 8. AI 설계

해당 없음. 이 앱은 AI를 사용하지 않음.

---

## 9. 기술 스택 + 아키텍처

### 기술 스택

| 영역 | 스택 |
|------|------|
| 프론트엔드 | Flutter (Dart) |
| 로컬 DB | sqflite |
| 상태관리 | flutter_riverpod |
| 알림 | flutter_local_notifications |
| 인앱결제 | RevenueCat (purchases_flutter) |
| 다국어 | flutter_localizations + ARB 파일 |
| 분석 | Firebase Analytics |
| 크래시 리포트 | Firebase Crashlytics |
| 이미지 생성 | 자체 구현 (RepaintBoundary → PNG export) |
| 백엔드 | 없음 (순수 클라이언트 앱) |

### 주요 패키지

```yaml
dependencies:
  flutter_riverpod: ^2.x
  sqflite: ^2.x
  path_provider: ^2.x
  flutter_local_notifications: ^17.x
  purchases_flutter: ^8.x
  firebase_core: ^3.x
  firebase_analytics: ^11.x
  firebase_crashlytics: ^4.x
  intl: ^0.19.x
  share_plus: ^10.x
  path: ^1.x
  emoji_picker_flutter: ^3.x
  google_fonts: ^6.x

dev_dependencies:
  flutter_launcher_icons: ^0.x
  flutter_native_splash: ^2.x
```

### 아키텍처

```
┌──────────────────────────────────┐
│         UI Layer                 │
│   (Screens / Widgets / Pages)    │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────┐
│      State Management Layer      │
│      (Riverpod Providers)        │
│  - ddayListProvider              │
│  - ddayDetailProvider            │
│  - milestoneProvider             │
│  - themeProvider                 │
│  - settingsProvider              │
│  - purchaseProvider              │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────┐
│       Repository Layer           │
│  - DdayRepository                │
│  - MilestoneRepository           │
│  - SettingsRepository            │
│  - PurchaseRepository            │
│  - NotificationRepository        │
└──────┬──────┬──────┬─────────────┘
       │      │      │
┌──────▼┐ ┌──▼────┐ ┌▼────────────┐
│sqflite│ │RevCat │ │LocalNotify   │
└───────┘ └───────┘ └─────────────┘
```

---

## 10. 프로젝트 폴더 구조

```
daycount/
├── lib/
│   ├── main.dart
│   ├── app.dart                          # MaterialApp, 라우팅, 테마
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart           # 컬러 상수
│   │   │   ├── app_strings.dart          # 키 상수 (settings 키 등)
│   │   │   └── app_config.dart           # 앱 설정 상수
│   │   ├── theme/
│   │   │   ├── app_theme.dart            # 라이트/다크 ThemeData
│   │   │   ├── card_themes.dart          # 카드 테마 정의 (무료+프리미엄)
│   │   │   └── theme_provider.dart       # 테마 상태관리
│   │   ├── utils/
│   │   │   ├── date_utils.dart           # 날짜 계산 유틸
│   │   │   ├── milestone_generator.dart  # 카테고리별 마일스톤 자동 생성
│   │   │   └── share_utils.dart          # 이미지 생성/공유 유틸
│   │   └── extensions/
│   │       └── datetime_ext.dart         # DateTime 확장
│   ├── data/
│   │   ├── database/
│   │   │   ├── database_helper.dart      # sqflite 초기화, 마이그레이션
│   │   │   └── database_constants.dart   # 테이블명, 컬럼명 상수
│   │   ├── models/
│   │   │   ├── dday.dart                 # D-Day 모델
│   │   │   ├── milestone.dart            # 마일스톤 모델
│   │   │   └── card_theme.dart           # 카드 테마 모델
│   │   └── repositories/
│   │       ├── dday_repository.dart      # D-Day CRUD
│   │       ├── milestone_repository.dart # 마일스톤 CRUD
│   │       ├── settings_repository.dart  # 설정 읽기/쓰기
│   │       ├── purchase_repository.dart  # RevenueCat 래핑
│   │       └── notification_repository.dart # 알림 스케줄링
│   ├── providers/
│   │   ├── dday_providers.dart           # D-Day 관련 프로바이더
│   │   ├── milestone_providers.dart      # 마일스톤 프로바이더
│   │   ├── settings_providers.dart       # 설정 프로바이더
│   │   ├── purchase_providers.dart       # 구매 상태 프로바이더
│   │   └── filter_providers.dart         # 정렬/필터 프로바이더
│   ├── features/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── dday_card.dart
│   │   │   │   ├── filter_chips.dart
│   │   │   │   └── empty_state.dart
│   │   ├── dday_detail/
│   │   │   ├── detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── counter_display.dart
│   │   │       ├── milestone_list.dart
│   │   │       └── sub_counts.dart
│   │   ├── dday_form/
│   │   │   ├── form_screen.dart
│   │   │   └── widgets/
│   │   │       ├── emoji_selector.dart
│   │   │       ├── category_chips.dart
│   │   │       └── theme_selector.dart
│   │   ├── timeline/
│   │   │   ├── timeline_screen.dart
│   │   │   └── widgets/
│   │   │       ├── timeline_node.dart
│   │   │       └── today_marker.dart
│   │   ├── share_card/
│   │   │   ├── share_card_screen.dart
│   │   │   └── widgets/
│   │   │       ├── card_preview.dart
│   │   │       └── template_selector.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   ├── pro_purchase/
│   │   │   └── pro_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   └── milestone_celebration/
│   │       └── celebration_dialog.dart
│   └── l10n/
│       ├── app_en.arb                    # 영어
│       └── app_ko.arb                    # 한국어
├── assets/
│   └── fonts/                            # 커스텀 폰트 (필요시)
├── android/
├── ios/
├── test/
├── pubspec.yaml
├── CLAUDE.md                             # Claude Code 지침 (Phase 5에서 생성)
└── README.md
```

---

## 11. API / 서버리스 함수 상세

해당 없음. 순수 클라이언트 앱으로 서버 API 없음.

외부 SDK 연동:
- **RevenueCat**: 인앱결제 처리 (구매/복원/구독 상태 확인)
- **Firebase Analytics**: 이벤트 로깅
- **Firebase Crashlytics**: 크래시 리포트

---

## 12. 수익 모델 + 비용 구조 + 수익 전망

### 수익 모델

| 항목 | 내용 |
|------|------|
| 상품명 | DayCount PRO |
| 타입 | Non-consumable (1회 구매, 영구) |
| 가격 | $3.99 (USD) / ₩4,900 (KRW) |
| 해금 기능 | 프리미엄 테마 10~15개 + 카테고리 특화 모드 + 공유 카드 커스텀 |
| 구매 복원 | 설정 화면 "Restore Purchase" 버튼 (Apple 필수 요구사항) |

### 비용 구조

| 항목 | 비용 |
|------|------|
| 서버 | 0원 (로컬 앱) |
| Firebase | 무료 티어 (Analytics + Crashlytics) |
| RevenueCat | 무료 (월 매출 $2,500 이하) |
| Apple Developer | $99/년 |
| Google Play Developer | $25 (1회) |
| **월 고정비** | **~$8.25** (Apple 연회비 월 환산) |

### 수수료

| 플랫폼 | 수수료 | 개발자 수익 (per sale) |
|--------|--------|----------------------|
| Apple (1년차) | 30% | $2.79 |
| Apple (2년차~) | 15% | $3.39 |
| Google Play | 15% | $3.39 |

### 수익 전망 (보수적 추정)

| 시나리오 | 월간 다운로드 | 전환율 | 월 매출 | 월 순수익 |
|----------|-------------|--------|---------|----------|
| 보수적 | 1,000 | 3% | $120 | ~$95 |
| 중간 | 5,000 | 5% | $1,000 | ~$800 |
| 낙관적 | 20,000 | 5% | $4,000 | ~$3,200 |

전제: 글로벌 출시, ASO 최적화 적용, 유료 마케팅 없음

---

## 13. 다국어 처리 전략

| 항목 | 내용 |
|------|------|
| 기본 언어 | 영어 (en) |
| 추가 언어 | 한국어 (ko) |
| 방식 | ARB 파일 (lib/l10n/app_en.arb, app_ko.arb) |
| 규칙 | **하드코딩 텍스트 절대 금지**, 모든 UI 문자열 ARB 관리 |
| 날짜 포맷 | 로케일 따라 자동 (en: "Mar 28, 2026" / ko: "2026.3.28") |
| 숫자 포맷 | 로케일 따라 자동 (intl 패키지) |
| 스토어 메타데이터 | 영어/한국어 별도 최적화 |
| 확장 계획 | v1.1+에서 일본어, 중국어 간체 추가 고려 |

---

## 14. 푸시 알림 시나리오 + 문구

모든 알림은 **로컬 알림** (flutter_local_notifications). 서버 푸시 없음.

| ID | 시나리오 | 타이밍 | 영어 문구 | 한국어 문구 |
|----|----------|--------|-----------|-------------|
| N01 | 마일스톤 7일 전 | D-7, 오전 9:00 | "7 days until {title} hits {milestone}!" | "{title} {milestone}까지 7일 남았어요!" |
| N02 | 마일스톤 3일 전 | D-3, 오전 9:00 | "Only 3 days to go! {title} - {milestone}" | "{title} {milestone}까지 3일!" |
| N03 | 마일스톤 당일 | D-Day, 오전 9:00 | "🎉 Today is {milestone} for {title}!" | "🎉 오늘은 {title} {milestone}이에요!" |
| N04 | D-Day 당일 | D-Day, 오전 9:00 | "🎉 Today is the day! {title}" | "🎉 오늘이에요! {title}" |

**알림 설정:**
- D-Day별 알림 ON/OFF 가능 (기본 ON)
- 전체 알림 ON/OFF (설정 화면)
- 알림 시간 변경: v2에서 고려 (MVP에선 오전 9:00 고정)

**알림 스케줄링 로직:**
- D-Day 생성/수정 시 관련 알림 일괄 스케줄링
- D-Day 삭제 시 관련 알림 일괄 취소
- 앱 시작 시 만료된 알림 정리 + 신규 마일스톤 알림 재스케줄링

---

## 15. 분석 이벤트 + 퍼널

### 이벤트 목록

| 이벤트명 | 설명 | 파라미터 |
|----------|------|----------|
| app_first_open | 첫 실행 | - |
| onboarding_complete | 온보딩 완료 | skipped: bool |
| dday_created | D-Day 생성 | category, theme_id |
| dday_edited | D-Day 수정 | dday_id |
| dday_deleted | D-Day 삭제 | category |
| theme_applied | 테마 적용 | theme_id, is_pro: bool |
| timeline_viewed | 타임라인 뷰 전환 | dday_count: int |
| share_card_created | 공유 카드 생성 | template_id |
| share_card_shared | 공유 카드 SNS 공유 완료 | share_target (platform) |
| share_card_saved | 공유 카드 갤러리 저장 | - |
| pro_purchase_tapped | PRO 구매 화면 진입 | source (settings/theme/share) |
| pro_purchase_completed | PRO 구매 완료 | price |
| pro_purchase_restored | 구매 복원 | success: bool |
| milestone_reached | 마일스톤 도달 | dday_id, milestone_days |
| notification_permission | 알림 권한 응답 | granted: bool |
| dark_mode_toggled | 다크모드 전환 | mode (system/light/dark) |
| filter_used | 필터 사용 | filter_type |
| custom_milestone_added | 커스텀 마일스톤 추가 | days: int |

### 핵심 퍼널

```
첫 실행 → 온보딩 완료 → 첫 D-Day 생성 → PRO 구매 화면 진입 → 구매 완료
```

**모니터링 지표:**
- D1/D7/D30 리텐션
- 유저당 평균 D-Day 생성 수
- PRO 전환율 (구매 화면 진입 → 완료)
- 공유 카드 생성률
- 타임라인 뷰 사용률

---

## 16. 스토어 출시 체크리스트

### Apple App Store

- [ ] Apple Developer 계정 ($99/년)
- [ ] 앱 아이콘 1024x1024
- [ ] 스크린샷: 6.7" (iPhone 15 Pro Max), 6.5" (iPhone 11 Pro Max), 5.5" (iPhone 8 Plus) — 최소 3장
- [ ] 개인정보처리방침 URL (GitHub Pages 호스팅)
- [ ] 앱 심사 정보: 인앱결제 테스트 안내 작성
- [ ] 연령 등급: 4+
- [ ] 인앱결제 상품 등록 (Non-consumable, DayCount PRO)
- [ ] ATT(App Tracking Transparency) 확인 — Firebase Analytics가 IDFA 수집 시 필요
- [ ] 메타데이터: Title, Subtitle, Keywords, Description (영어+한국어)

### Google Play

- [ ] Google Play Developer 계정 ($25 1회)
- [ ] 앱 아이콘 512x512
- [ ] Feature Graphic 1024x500
- [ ] 스크린샷: 최소 2장, 권장 4~8장 (폰+태블릿)
- [ ] 개인정보처리방침 URL
- [ ] 콘텐츠 등급 설문 작성
- [ ] 데이터 안전 섹션 작성
- [ ] 인앱결제 상품 등록
- [ ] 메타데이터: Title, Short Description, Full Description (영어+한국어)

---

## 17. 법적 문서

### 수집 데이터 요약

| 데이터 | 수집 방법 | 용도 | 서버 전송 |
|--------|----------|------|----------|
| D-Day 데이터 (이름, 날짜 등) | 유저 입력 | 앱 기능 | ❌ 로컬만 |
| 기기 식별자 | Firebase Analytics SDK | 앱 사용 통계 | ✅ Firebase |
| 크래시 로그 | Firebase Crashlytics SDK | 버그 수정 | ✅ Firebase |
| 구매 영수증 | RevenueCat SDK | 결제 처리 | ✅ RevenueCat |

### 필요 문서

1. **Privacy Policy (개인정보처리방침)** — 영어 전문. GitHub Pages에 호스팅
2. **Terms of Service (이용약관)** — 영어 전문. 앱 사용 조건, 환불 정책(스토어 정책 따름)
3. **Disclaimer (면책 조항)** — 알림 미전달로 인한 기념일 누락 등에 대한 책임 제한

> 법적 문서 전문은 출시 준비 단계(Phase 7)에서 별도 작성

---

## 18. 개발 일정 + 마일스톤

| 주차 | 마일스톤 | 상세 내용 | 산출물 |
|------|----------|----------|--------|
| **W1 전반** | M1: 프로젝트 셋업 + 핵심 CRUD | Flutter 프로젝트 초기화, sqflite 세팅, D-Day 모델/DB, 생성/수정/삭제, 카드형 리스트, 빈 상태 화면, 온보딩 | 앱 기본 골격 동작 |
| **W1 후반** | M2: 테마 시스템 + 다크모드 | 테마 엔진 구축 (CardTheme 모델), 기본 6개 + 프리미엄 테마 정의, 카드별 테마 적용, 다크모드 (시스템/수동), 설정 화면 | 테마 적용된 카드 UI |
| **W2 전반** | M3: 마일스톤 + 알림 | 마일스톤 자동 생성 로직, 마일스톤 CRUD, flutter_local_notifications 연동, 알림 스케줄링, 마일스톤 축하 다이얼로그 | 알림 동작 확인 |
| **W2 후반** | M4: 카테고리 특화 + 타임라인 | 카테고리별 마일스톤 생성 로직, 특화 UI (커플/시험/육아), 타임라인 뷰 (세로 축, TODAY 마커), 뷰 토글 | 전체 핵심 기능 완성 |
| **W3 전반** | M5: 공유카드 + 인앱결제 + 다국어 | RepaintBoundary 이미지 생성, 템플릿 선택, 갤러리 저장/SNS 공유, RevenueCat 연동, PRO 구매 화면, ARB 파일 영어+한국어 | 수익화 + 다국어 완료 |
| **W3 후반** | M6: QA + 폴리싱 + 스토어 제출 | Firebase Analytics/Crashlytics 연동, 전체 QA, 버그 수정, 애니메이션 폴리싱, 스크린샷, 메타데이터, 법적 문서, 스토어 제출 | 스토어 제출 완료 |

---

## 19. QA 테스트 체크리스트

### CRUD

- [ ] D-Day 생성: 모든 필드 정상 저장
- [ ] D-Day 수정: 변경사항 즉시 반영
- [ ] D-Day 삭제: 확인 다이얼로그 → 삭제 → 관련 마일스톤/알림 함께 삭제
- [ ] 빈 제목 저장 방지
- [ ] 날짜 미선택 저장 방지

### 카드 UI

- [ ] 테마별 그라데이션 정상 렌더링
- [ ] 카운트다운 (미래 날짜): 양수 + "days left"
- [ ] 카운트업 (과거 날짜): +N + "days ago"
- [ ] 즐겨찾기 토글 동작
- [ ] 카드 탭 → 상세 화면 이동

### 정렬/필터

- [ ] 날짜순 (가까운순/먼순) 정렬
- [ ] 카테고리별 필터
- [ ] 즐겨찾기 필터
- [ ] 필터 조합 동작

### 마일스톤

- [ ] 카테고리별 자동 생성 정확성 (일반: 100/200/365, 커플: 100일 단위, 육아: 개월수)
- [ ] 커스텀 마일스톤 추가/삭제
- [ ] 과거 마일스톤 "Reached ✨" 표시
- [ ] 미래 마일스톤 "N days left" 표시

### 알림

- [ ] 알림 권한 요청 정상 동작
- [ ] 마일스톤 7일전/3일전/당일 알림 예약 확인
- [ ] D-Day 당일 알림 예약 확인
- [ ] D-Day별 알림 ON/OFF 토글
- [ ] D-Day 삭제 시 알림 취소
- [ ] 알림 탭 시 앱 열림 → 해당 상세 화면

### 타임라인

- [ ] 뷰 토글 전환 애니메이션
- [ ] 날짜 기준 정렬 정확성
- [ ] TODAY 마커 위치 정확성
- [ ] 과거 이벤트 투명도 처리
- [ ] 노드 탭 → 상세 화면 이동

### 공유 카드

- [ ] 이미지 생성 (RepaintBoundary → PNG)
- [ ] 템플릿 선택 → 미리보기 반영
- [ ] 갤러리 저장 (권한 요청 포함)
- [ ] SNS 공유 시트 정상 동작
- [ ] 프리미엄 템플릿 잠금 표시

### 인앱결제

- [ ] PRO 구매 플로우 (RevenueCat)
- [ ] 구매 완료 → 즉시 잠금 해제
- [ ] 구매 복원 동작
- [ ] 복원 실패 시 에러 메시지
- [ ] 네트워크 없을 때 처리

### 다국어

- [ ] 영어 ↔ 한국어 전환
- [ ] 누락 문자열 없는지 (모든 화면)
- [ ] 날짜 포맷 로케일별 정상 표시
- [ ] 긴 텍스트 오버플로우 없는지

### 다크모드

- [ ] 라이트 → 다크 전환
- [ ] 시스템 설정 연동
- [ ] 모든 화면 다크모드 정상
- [ ] 카드 테마 + 다크모드 조합

### 엣지케이스

- [ ] D-Day 0개: 빈 상태 화면 표시
- [ ] D-Day 100개+: 스크롤 성능
- [ ] 아주 먼 과거 날짜 (1990년)
- [ ] 아주 먼 미래 날짜 (2090년)
- [ ] 오늘 날짜 D-Day (0일)
- [ ] 자정 전후 일수 계산 정확성

### 기기 대응

- [ ] iOS: iPhone SE (소형), iPhone 15 Pro Max (대형)
- [ ] Android: 소형 (5"), 대형 (6.7"+)
- [ ] 태블릿 레이아웃 (최소 깨지지 않는 수준)
- [ ] 노치/다이나믹 아일랜드 SafeArea

---

## 20. 디자인 가이드라인

### 디자인 톤

미니멀 + 감성. 깔끔하되 따뜻한 느낌.

### 컬러 시스템

| 용도 | 라이트 모드 | 다크 모드 |
|------|------------|----------|
| 배경 | #FAFAFA | #1A1A2E |
| 서피스 | #FFFFFF | #252542 |
| 프라이머리 | #6C63FF | #6C63FF |
| 세컨더리 | #FF6B8A | #FF6B8A |
| 액센트 | #43E8D8 | #43E8D8 |
| 텍스트 (주) | #1A1A2E | #E8E8FF |
| 텍스트 (보조) | #666666 | #A0A0C0 |
| 디바이더 | #E8E8F0 | #3A3A5C |

### 기본 테마 (무료 6개)

| ID | 테마명 | 카드 배경 그라데이션 | 텍스트 | 액센트 |
|----|--------|---------------------|--------|--------|
| cloud | Cloud | #F0F0FF → #E8E8FF | #2D2D3F | #6C63FF |
| sunset | Sunset | #FFF0E6 → #FFE0CC | #8B4513 | #FF6B3D |
| ocean | Ocean | #E6F5FF → #CCE8FF | #1A5276 | #2E86DE |
| forest | Forest | #E8F5E9 → #C8E6C9 | #1B5E20 | #43A047 |
| lavender | Lavender | #F3E5F5 → #E1BEE7 | #4A148C | #9C27B0 |
| minimal | Minimal | #FFFFFF → #F5F5F5 | #212121 | #6C63FF |

### 프리미엄 테마 (유료)

| ID | 테마명 | 카드 배경 그라데이션 | 텍스트 | 액센트 |
|----|--------|---------------------|--------|--------|
| midnight | Midnight | #1A1A2E → #16213E | #E8E8FF | #6C63FF |
| cherry | Cherry | #B71C1C → #E53935 | #FFFFFF | #FFCDD2 |
| aurora | Aurora | #0F2027 → #2C5364 | #43E8D8 | #43E8D8 |
| peach | Peach | #FFECD2 → #FCB69F | #5D4037 | #FF7043 |
| noir | Noir | #232526 → #414345 | #FAFAFA | #FFD700 |

> 추가 프리미엄 테마는 출시 후 유저 반응 보며 확장

### 타이포그래피

| 용도 | 폰트 | 사이즈 | Weight |
|------|------|--------|--------|
| 앱 타이틀 | Outfit (Google Fonts) | 22 | Bold (700) |
| 카드 제목 | Outfit | 16 | Bold (700) |
| 큰 숫자 (일수) | Outfit | 36~72 | ExtraBold (800) |
| 본문 | Outfit | 14 | Regular (400) |
| 캡션 | Outfit | 11~12 | SemiBold (600) |

한국어: Pretendard 또는 시스템 폰트 fallback

### 카드 스타일

- border-radius: 20px
- 그라데이션 방향: 135deg
- 장식 원: 우측 상단 accent 컬러 10% opacity
- 패딩: 20px
- 즐겨찾기: 우상단 ⭐

### 애니메이션

| 요소 | 효과 | 지속시간 |
|------|------|----------|
| 카드 등장 | fadeSlideIn (아래→위) | 400ms, stagger 80ms |
| 뷰 전환 (리스트↔타임라인) | fade + slide | 300ms |
| 마일스톤 축하 | confetti 파티클 | 2000ms |
| 온보딩 이모지 | 부드러운 pulse | 2000ms loop |
| PRO 왕관 | 흔들림 shimmer | 2000ms loop |
| FAB | 고정, 탭시 scale bounce | 200ms |

---

## 21. 앱스토어 메타데이터

### App Store (iOS)

| 항목 | 영어 | 한국어 |
|------|------|--------|
| Title (30자) | DayCount - D-Day Countdown | DayCount - 디데이 카운터 |
| Subtitle (30자) | Milestone Tracker & Anniversary | 기념일 마일스톤 & 카운트다운 |
| Keywords (100자) | dday,countdown,anniversary,milestone,tracker,event,reminder,couple,baby,exam,birthday,calendar,date | 디데이,기념일,카운트다운,마일스톤,커플,시험,육아,생일,디데이카운터,날짜,알림 |
| Category (Primary) | Lifestyle | Lifestyle |
| Category (Secondary) | Utilities | Utilities |

### Google Play

| 항목 | 영어 | 한국어 |
|------|------|--------|
| Title (30자) | DayCount - D-Day Countdown | DayCount - 디데이 카운터 |
| Short Desc (80자) | Beautiful D-Day counter with milestone alerts. Track anniversaries, exams & more. | 예쁜 디데이 카운터. 기념일, 마일스톤 알림을 한눈에. |
| Category | Lifestyle | Lifestyle |

### Full Description (영어)

```
Track your most important days with DayCount — the beautiful D-Day counter that makes every milestone special.

Whether it's your anniversary, an upcoming exam, your baby's growth milestones, or any special date — DayCount helps you count every day with style.

KEY FEATURES

• Beautiful Card Design — Each D-Day gets a stunning card with gradient themes. Your dates deserve to look amazing.

• Milestone Alerts — Never miss 100 days, 200 days, 1 year, or any milestone. Get notified 7 days before, 3 days before, and on the day.

• Timeline View — See all your events on a beautiful timeline. Past and future, all at a glance.

• Category Modes — Specialized tracking for couples (100-day anniversaries), exams (weeks & months countdown), and baby milestones (months & growth stages).

• Share Cards — Create beautiful share cards and post them on Instagram, send to friends, or save to your gallery.

• No Account Required — Start tracking immediately. No sign-up, no login. Your data stays on your device.

• Dark Mode — Beautiful in light and dark. Follows your system setting or switch manually.

UPGRADE TO PRO

Unlock 15+ premium themes, category special modes, and custom share card templates with a one-time purchase. No subscriptions, no ads — ever.

DayCount. Every day counts.
```

### Full Description (한국어)

```
소중한 날을 예쁘게 세어보세요 — DayCount, 모든 마일스톤을 특별하게 만드는 디데이 카운터.

연인과의 기념일, 다가오는 시험, 아기의 성장 기록, 그 어떤 특별한 날이든 — DayCount와 함께 하루하루를 감성적으로 기록하세요.

주요 기능

• 감성 카드 디자인 — 각 D-Day마다 아름다운 그라데이션 테마 카드. 캡처해서 공유하고 싶은 디자인.

• 마일스톤 알림 — 100일, 200일, 1주년… 절대 놓치지 마세요. 7일 전, 3일 전, 당일 알림.

• 타임라인 뷰 — 내 인생의 모든 이벤트를 타임라인 위에. 과거와 미래를 한눈에.

• 카테고리 모드 — 커플(100일 단위 기념일), 시험(남은 주/월), 육아(개월수/성장 마일스톤) 특화 기능.

• 공유 카드 — 예쁜 이미지 카드를 만들어 인스타, 카카오톡, 어디든 공유하세요.

• 가입 필요 없음 — 바로 시작. 로그인 없이. 데이터는 내 폰에만 저장.

• 다크모드 — 라이트도 다크도 예쁘게. 시스템 설정 연동 또는 수동 전환.

PRO 업그레이드

15개 이상의 프리미엄 테마, 카테고리 특화 모드, 공유 카드 커스텀을 1회 구매로 영구 해금. 구독 없음, 광고 없음.

DayCount. 모든 날이 소중하니까.
```

---

## 22. 출시 후 로드맵

| 버전 | 내용 | 예상 시기 |
|------|------|----------|
| **v1.0** | MVP 출시 | W3 |
| **v1.1** | 유저 피드백 반영, 버그 수정, 프리미엄 테마 5개 추가 | v1.0 + 2주 |
| **v1.2** | 알림 시간 커스텀, 추가 언어 (일본어/중국어 간체) | v1.1 + 2주 |
| **v2.0** | 홈 화면 위젯 (iOS WidgetKit + Android Glance) | v1.2 + 4주 |
| **v2.1** | 클라우드 백업/동기화 (Firebase Auth + Firestore) | v2.0 + 2주 |
| **v3.0** | 소셜 기능 (친구 기념일 공유), Apple Watch | 장기 |

---

> **문서 끝 — DayCount v1.0 상세 기획서**
