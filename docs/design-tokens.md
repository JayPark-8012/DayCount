# DayCount — Design Tokens

> 모든 UI 구현 시 이 문서의 값을 참조. 임의 컬러/사이즈 사용 금지.

---

## 1. 컬러 시스템

### 앱 전역 컬러

| 용도 | 라이트 모드 | 다크 모드 | 변수명 |
|------|------------|----------|--------|
| 배경 | `#FAFAFA` | `#1A1A2E` | `backgroundColor` |
| 서피스 | `#FFFFFF` | `#252542` | `surfaceColor` |
| 프라이머리 | `#6C63FF` | `#6C63FF` | `primaryColor` |
| 세컨더리 | `#FF6B8A` | `#FF6B8A` | `secondaryColor` |
| 액센트 | `#43E8D8` | `#43E8D8` | `accentColor` |
| 텍스트 (주) | `#1A1A2E` | `#E8E8FF` | `textPrimary` |
| 텍스트 (보조) | `#666666` | `#A0A0C0` | `textSecondary` |
| 텍스트 (비활성) | `#999999` | `#666680` | `textDisabled` |
| 디바이더 | `#E8E8F0` | `#3A3A5C` | `dividerColor` |
| 에러 | `#E53935` | `#EF5350` | `errorColor` |
| 성공 | `#43A047` | `#66BB6A` | `successColor` |

### 프라이머리 그라데이션

```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
)
```

### 로고 그라데이션

```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6C63FF), Color(0xFFFF6B8A)],
)
```

---

## 2. 카드 테마 — 전체 정의 (무료 6 + 프리미엄 15 = 21개)

### 무료 테마 (6개)

| ID | 이름 | 배경 시작 | 배경 끝 | 텍스트 | 액센트 |
|----|------|----------|---------|--------|--------|
| `cloud` | Cloud | `#F0F0FF` | `#E8E8FF` | `#2D2D3F` | `#6C63FF` |
| `sunset` | Sunset | `#FFF0E6` | `#FFE0CC` | `#8B4513` | `#FF6B3D` |
| `ocean` | Ocean | `#E6F5FF` | `#CCE8FF` | `#1A5276` | `#2E86DE` |
| `forest` | Forest | `#E8F5E9` | `#C8E6C9` | `#1B5E20` | `#43A047` |
| `lavender` | Lavender | `#F3E5F5` | `#E1BEE7` | `#4A148C` | `#9C27B0` |
| `minimal` | Minimal | `#FFFFFF` | `#F5F5F5` | `#212121` | `#6C63FF` |

### 프리미엄 테마 (15개)

| ID | 이름 | 배경 시작 | 배경 끝 | 텍스트 | 액센트 |
|----|------|----------|---------|--------|--------|
| `midnight` | Midnight | `#1A1A2E` | `#16213E` | `#E8E8FF` | `#6C63FF` |
| `cherry` | Cherry | `#B71C1C` | `#E53935` | `#FFFFFF` | `#FFCDD2` |
| `aurora` | Aurora | `#0F2027` | `#2C5364` | `#43E8D8` | `#43E8D8` |
| `peach` | Peach | `#FFECD2` | `#FCB69F` | `#5D4037` | `#FF7043` |
| `noir` | Noir | `#232526` | `#414345` | `#FAFAFA` | `#FFD700` |
| `rosegold` | Rose Gold | `#F4C4C4` | `#E8A8A8` | `#5D3A3A` | `#C97B7B` |
| `arctic` | Arctic | `#E0F2F7` | `#B2E0F0` | `#0D3B66` | `#1E88E5` |
| `ember` | Ember | `#FF8A65` | `#FF5722` | `#FFFFFF` | `#FFE0B2` |
| `sage` | Sage | `#D5E1D5` | `#B5C9B5` | `#2E4A2E` | `#5C8A5C` |
| `twilight` | Twilight | `#2D1B69` | `#1A1A4E` | `#D4C5FF` | `#B39DDB` |
| `mocha` | Mocha | `#D7CCC8` | `#BCAAA4` | `#3E2723` | `#795548` |
| `ocean_deep` | Ocean Deep | `#0D1B2A` | `#1B3A4B` | `#A8D8EA` | `#48CAE4` |
| `cotton_candy` | Cotton Candy | `#F8BBD0` | `#CE93D8` | `#4A148C` | `#E040FB` |
| `graphite` | Graphite | `#37474F` | `#546E7A` | `#ECEFF1` | `#90A4AE` |
| `royal` | Royal | `#1A237E` | `#283593` | `#E8EAF6` | `#FFD700` |

### 그라데이션 공통 설정

```dart
// 모든 카드 테마 배경
LinearGradient(
  begin: Alignment.topLeft,    // 135deg
  end: Alignment.bottomRight,
  colors: [startColor, endColor],
)
```

---

## 3. 타이포그래피

### 폰트 패밀리

| 언어 | 폰트 | 패키지 |
|------|------|--------|
| 영어/숫자 | Outfit | google_fonts |
| 한국어 | 시스템 기본 (Pretendard fallback) | - |

### 타입 스케일

| 용도 | 사이즈 | Weight | 변수명 |
|------|--------|--------|--------|
| 앱 타이틀 | 22 | Bold (700) | `titleLarge` |
| 섹션 헤더 | 17 | Bold (700) | `titleMedium` |
| 카드 제목 | 16 | Bold (700) | `titleSmall` |
| 큰 숫자 (홈 카드) | 36 | ExtraBold (800) | `displaySmall` |
| 큰 숫자 (상세 메인) | 72 | ExtraBold (800) | `displayLarge` |
| 큰 숫자 (상세 서브) | 22 | ExtraBold (800) | `displayMedium` |
| 큰 숫자 (타임라인) | 22 | ExtraBold (800) | `displayMedium` |
| 큰 숫자 (공유 카드) | 64 | ExtraBold (800) | - |
| 본문 | 14 | Regular (400) | `bodyMedium` |
| 버튼 텍스트 | 15~16 | Bold (700) | `labelLarge` |
| 캡션 | 12 | SemiBold (600) | `bodySmall` |
| 아주 작은 텍스트 | 11 | SemiBold (600) | `labelSmall` |
| 필터 칩 | 13 | SemiBold (600) | - |
| PRO 가격 | 40 | ExtraBold (800) | - |

### 레터 스페이싱

| 용도 | 값 |
|------|-----|
| 타이틀 | -0.5 |
| 큰 숫자 (36+) | -1.0 ~ -3.0 (사이즈에 비례) |
| 본문 | 0 (기본) |

---

## 4. 스페이싱 시스템

### 기본 단위: 4px

| 이름 | 값 | 용도 |
|------|-----|------|
| `xs` | 4 | 아이콘-텍스트 간격 |
| `sm` | 8 | 칩 간격, 요소 내부 |
| `md` | 12 | 카드 간 간격, 섹션 내 |
| `lg` | 16 | 섹션 간, 카드 내부 padding |
| `xl` | 20 | 화면 좌우 padding |
| `xxl` | 24 | 섹션 간 큰 간격 |
| `xxxl` | 32 | 화면 상하 여백 |

### 화면 padding
- 좌우: 20px (xl)
- 상단 (앱바 아래): 8~12px
- 하단 (FAB 위): 100px (FAB 가리지 않도록)

---

## 5. 보더 & 라디우스

| 요소 | 라디우스 | 용도 |
|------|---------|------|
| 카드 (D-Day) | 20 | 홈, 타임라인 카드 |
| 카드 (마일스톤 아이템) | 14 | 상세 화면 마일스톤 리스트 |
| 카드 (서브 카운트) | 14 | 상세 화면 주/월/일 카드 |
| 카드 (공유 카드) | 28 | 공유 카드 미리보기 |
| 필터 칩 | 20 | 필러 형태 |
| 버튼 (메인) | 16 | CTA 버튼 |
| 앱바 아이콘 버튼 | 10 | 뷰 토글, 설정 |
| 바텀시트 상단 | 28 | 상세 화면 하단 영역 |
| 로고 아이콘 | 10 | 앱바 로고 |
| 테마 선택 서클 | 12 | 정사각형 rounded |
| FAB | 18 | 우하단 추가 버튼 |
| 마일스톤 마커 | 50% (원) | 타임라인 노드 |

---

## 6. 그림자 & 엘리베이션

| 요소 | 그림자 |
|------|--------|
| D-Day 카드 | 없음 (그라데이션으로 깊이감) |
| FAB | `0 8px 24px rgba(108, 99, 255, 0.4)` |
| 메인 CTA 버튼 | `0 6px 20px rgba(108, 99, 255, 0.3)` |
| PRO 구매 버튼 | `0 8px 24px rgba(255, 215, 0, 0.3)` |
| 공유 카드 미리보기 | `0 20px 50px rgba(0, 0, 0, 0.15)` |
| 모달/다이얼로그 | `0 16px 40px rgba(0, 0, 0, 0.2)` |

---

## 7. 애니메이션 스펙

| 요소 | 효과 | Duration | Curve | 상세 |
|------|------|----------|-------|------|
| 카드 등장 | fadeSlideIn (Y: 16→0) | 400ms | easeOut | stagger: 80ms per card |
| 마일스톤 아이템 등장 | fadeSlideIn (Y: 12→0) | 300ms | easeOut | stagger: 50ms |
| 뷰 전환 (리스트↔타임라인) | AnimatedSwitcher (fade+slide) | 300ms | easeInOut | - |
| 마일스톤 축하 confetti | confetti_widget | 2000ms | - | 파티클 수: 50, 중력: 0.1 |
| 온보딩 이모지 | pulse (scale 1→1.08→1) | 2000ms | easeInOut | infinite loop |
| PRO 왕관 | shimmer (scale+rotate) | 2000ms | easeInOut | infinite loop |
| FAB 탭 | scale bounce (1→0.9→1) | 200ms | easeOut | - |
| 필터 칩 선택 | 색상 전환 | 200ms | easeOut | AnimatedContainer |
| 페이지 전환 | Material default | 300ms | - | Navigator push/pop |
| dot indicator 전환 | width 8→24 + 색상 | 300ms | easeOut | AnimatedContainer |
| TODAY 마커 글로우 | boxShadow pulse | 2000ms | easeInOut | infinite loop |

---

## 8. 아이콘 시스템

### 앱바 아이콘

| 위치 | 아이콘 | 사이즈 |
|------|--------|--------|
| 뒤로가기 | `←` (텍스트 또는 Icons.arrow_back_ios) | 18 |
| 뷰 토글 (리스트) | `📋` | 16 |
| 뷰 토글 (타임라인) | `📊` | 16 |
| 설정 | `⚙️` | 16 |
| 수정 | `✏️` | 16 |

### 앱바 아이콘 버튼 스타일

```dart
// 라이트 모드
Container(
  width: 36, height: 36,
  decoration: BoxDecoration(
    color: Color(0xFFF0F0F5),
    borderRadius: BorderRadius.circular(10),
  ),
)

// 다크 모드
Container(
  width: 36, height: 36,
  decoration: BoxDecoration(
    color: Color(0xFF252542),
    borderRadius: BorderRadius.circular(10),
  ),
)
```

### 카테고리 이모지 기본값

| 카테고리 | 기본 이모지 | 추천 이모지 세트 |
|----------|-----------|----------------|
| general | 📅 | 📅 🎉 🎊 ⭐ 🏆 🎯 📌 |
| couple | 💕 | 💕 ❤️ 💑 💍 🌹 💝 😍 |
| exam | 📚 | 📚 ✏️ 🎓 📝 💪 🧠 📖 |
| baby | 👶 | 👶 🍼 🎂 👣 🧸 🌟 💖 |

---

## 9. 카드 장식 요소

### 홈 카드 장식 원

```dart
Positioned(
  right: -20, top: -20,
  child: Container(
    width: 100, height: 100,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: accentColor.withOpacity(0.1),
    ),
  ),
)
```

### 공유 카드 장식

```dart
// 우상단 큰 원
Positioned(right: -40, top: -40, child: Circle(160, opacity: 0.08))
// 좌하단 작은 원
Positioned(left: -30, bottom: -30, child: Circle(120, opacity: 0.06))
```

### 타임라인 라인

```dart
Container(
  width: 2,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF6C63FF),
        Color(0xFFFF6B8A),
        Color(0xFF43E8D8),
      ],
    ),
  ),
)
// opacity: 0.3
```

---

## 10. 공유 카드 레이아웃

### 카드 사이즈
- 비율: 1:1 (정사각형)
- 렌더링 사이즈: 1080 x 1080 px (고해상도 export)
- 미리보기: 화면 너비 - 60px (좌우 30px padding)

### 레이아웃 구조

```
┌─────────────────────┐
│                     │
│    [장식 원 우상단]   │
│                     │
│      [이모지 48pt]   │
│                     │
│    [제목 18pt Bold]  │
│                     │
│   [일수 64pt XBold]  │
│  [days together 14pt]│
│                     │
│    [장식 원 좌하단]   │
│                     │
│        DayCount     │  ← 워터마크 10pt, opacity 0.3
└─────────────────────┘
```

### Export 방법

```dart
// RepaintBoundary 키
final globalKey = GlobalKey();

// 캡처
RenderRepaintBoundary boundary =
    globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
ui.Image image = await boundary.toImage(pixelRatio: 3.0); // 고해상도
ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
Uint8List pngBytes = byteData!.buffer.asUint8List();
```

---

## 11. 빈 상태 (Empty State)

### 홈 화면 — D-Day 0개

```
        📅
  (opacity 0.5, size 64)

  Add your first D-Day!
  (textSecondary, 16pt, SemiBold)

  Track your important dates
  with beautiful cards.
  (textDisabled, 14pt, Regular)

  ┌──────────────────┐
  │  + Create D-Day  │
  └──────────────────┘
  (프라이머리 버튼)
```

### 필터 결과 0개

```
  🔍
  No D-Days found
  Try a different filter.
```

### 마일스톤 0개 (커스텀만 표시 모드 시)

```
  🎯
  No milestones yet
  Tap "+ Custom" to add one.
```

---

## 12. PRO 뱃지 & 잠금 UI

### PRO 뱃지 (테마 선택 시)

```dart
Positioned(
  top: -4, right: -4,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
    decoration: BoxDecoration(
      color: Color(0xFFFFD700),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text("PRO", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.black)),
  ),
)
```

### 잠금 오버레이 (카테고리 특화 UI)

```dart
Stack(
  children: [
    // 실제 콘텐츠 (블러 처리)
    ClipRect(child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: content)),
    // 오버레이
    Center(child: Column(children: [
      Icon(Icons.lock, color: primaryColor),
      Text("Unlock with PRO"),
      TextButton("Learn More", onPressed: () => goToProScreen()),
    ])),
  ],
)
```

---

## 13. 앱 아이콘

### 디자인

- 형태: 둥근 사각형 (iOS: 자동, Android: adaptive icon)
- 배경: 프라이머리→세컨더리 그라데이션 (`#6C63FF` → `#FF6B8A`, 135deg)
- 전경: 흰색 "D" 글자
  - 폰트: Outfit ExtraBold
  - 사이즈: 아이콘의 50% 높이
  - 위치: 중앙
- 사이즈: 1024x1024 (iOS), 512x512 (Google Play)

### Android Adaptive Icon

- 배경 레이어: 그라데이션
- 전경 레이어: 흰색 "D"
- safe zone 내에 "D"가 들어가도록

---

## 14. 스플래시 화면

| 항목 | 라이트 | 다크 |
|------|--------|------|
| 배경색 | `#FAFAFA` | `#1A1A2E` |
| 로고 | 앱 아이콘 (중앙, 120x120) | 동일 |
| 지속 시간 | 앱 초기화 완료까지 (보통 1~2초) | 동일 |

flutter_native_splash 설정:
```yaml
flutter_native_splash:
  color: "#FAFAFA"
  color_dark: "#1A1A2E"
  image: assets/splash_logo.png
  image_dark: assets/splash_logo.png
```

---

## 15. FAB (Floating Action Button)

```dart
Positioned(
  bottom: 28, right: 20,
  child: Container(
    width: 56, height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF6C63FF).withOpacity(0.4),
          blurRadius: 24, offset: Offset(0, 8),
        ),
      ],
    ),
    child: Center(child: Text("+", style: TextStyle(fontSize: 28, color: Colors.white))),
  ),
)
```
