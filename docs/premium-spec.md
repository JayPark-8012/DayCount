# DayCount — Premium (PRO) Specification

---

## 1. 상품 정보

| 항목 | 내용 |
|------|------|
| 상품명 | DayCount PRO |
| Product ID | `daycount_pro` |
| 타입 | Non-consumable (1회 구매, 영구) |
| 가격 | $3.99 (USD) / ₩4,900 (KRW) |
| Entitlement ID (RevenueCat) | `pro` |
| Offering ID (RevenueCat) | `default` |

---

## 2. 무료 vs 유료 기능 전체 맵

### 무료 기능 (제한 없음)

| 기능 | 상세 |
|------|------|
| D-Day 생성/수정/삭제 | 개수 무제한 |
| 카드형 리스트 뷰 | 전체 기능 |
| D-Day 상세 화면 | 일수, 주/월 환산, 기본 마일스톤 |
| 카테고리 태그 | 일반/커플/시험/육아 선택 가능 |
| 카테고리 특화 UI/계산 | 커플(100일 기념일 마일스톤), 시험(남은 주/월 강조), 육아(개월수/성장 마일스톤) |
| 기본 테마 6개 | Cloud, Sunset, Ocean, Forest, Lavender, Minimal |
| 마일스톤 자동 생성 | 카테고리별 자동 |
| 마일스톤 사전 알림 | 7일전, 3일전, 당일 |
| 커스텀 마일스톤 추가 | 원하는 일수 직접 추가 |
| 타임라인 뷰 | 전체 기능 |
| 공유 카드 (기본 템플릿 + 기본 폰트) | 기본 6개 테마 + Outfit 폰트, 워터마크 포함 |
| 정렬/필터 | 전체 기능 |
| 다크모드 | 전체 기능 |
| 다국어 | 전체 기능 |

### 유료 기능 (PRO)

| 기능 | 상세 | 잠금 위치 |
|------|------|----------|
| 프리미엄 테마 15개 | Midnight, Cherry, Aurora 등 | S03 생성/수정 → 테마 선택 |
| 공유 카드 프리미엄 템플릿 15개 | 다크 계열, 럭셔리 테마 카드 | S06 공유 카드 → 템플릿 선택 |
| 공유 카드 배경 사진 | 갤러리에서 사진 선택, 오버레이 + 그라데이션 | S06 공유 카드 → 배경 [📸 사진] |
| 공유 카드 프리미엄 폰트 4종 | Caveat, Dancing Script, Poppins, Playfair Display | S06 공유 카드 → 폰트 선택 |
| 워터마크 제거 | 공유 카드에서 "DayCount" 워터마크 제거 | S06 공유 카드 (자동 적용) |

---

## 3. 잠금 체크 구현

### 중앙 관리

```dart
// providers/purchase_providers.dart
final isProProvider = StateProvider<bool>((ref) => false);

// 앱 시작 시 RevenueCat 동기화
Future<void> syncPurchaseStatus(WidgetRef ref) async {
  try {
    final customerInfo = await Purchases.getCustomerInfo();
    final isPro = customerInfo.entitlements.active.containsKey('pro');
    ref.read(isProProvider.notifier).state = isPro;
    // settings DB에도 캐싱
    await ref.read(settingsRepositoryProvider).set('is_pro', isPro.toString());
  } catch (e) {
    // 네트워크 에러 시 캐시된 값 사용
    final cached = await ref.read(settingsRepositoryProvider).getBool('is_pro');
    ref.read(isProProvider.notifier).state = cached ?? false;
  }
}
```

### 잠금 체크 포인트

| 위치 | 체크 방법 | 잠겼을 때 |
|------|----------|----------|
| S03 테마 선택 | `theme.isPro && !ref.watch(isProProvider)` | PRO 뱃지 표시, 탭 시 S08 이동 |
| S06 프리미엄 템플릿 | `theme.isPro && !ref.watch(isProProvider)` | PRO 뱃지 표시, 탭 시 S08 이동 |
| S06 배경 사진 | `!ref.read(isProProvider)` | 📸 사진 탭 시 S08 이동 |
| S06 프리미엄 폰트 | `font.isPro && !ref.watch(isProProvider)` | PRO 뱃지 표시, 탭 시 S08 이동 |
| S06 워터마크 | `!ref.watch(isProProvider)` | 무료 유저: 워터마크 표시 (자동) |

---

## 4. 잠금 UI 패턴

### 패턴 A: PRO 뱃지 (테마/템플릿/폰트 선택)

```
┌──────┐
│      │
│ [컬러]│
│      │  ← 테마/템플릿 미리보기 서클 (40x40) 또는 폰트 칩
└──────┘
  [PRO]   ← 우상단 뱃지 (금색, 8pt)
```

- 서클/칩은 정상 표시 (어떤 컬러/폰트인지 볼 수 있음)
- 우상단에 금색 PRO 뱃지
- 탭 시 → S08 PRO 구매 화면으로 이동
- 적용 위치: S03 테마 선택, S06 템플릿 선택, S06 폰트 선택
- 분석 이벤트: `pro_purchase_tapped` (source: "theme" 또는 "share_template")

### 패턴 B: 설정 화면 PRO 배너

```
┌─────────────────────────────┐
│  👑  DayCount PRO            │
│  Unlock all themes &         │
│  features                    │
│                         →    │
└─────────────────────────────┘
```

- 설정 화면 최상단
- PRO 미구매 시에만 표시
- 배경: 프라이머리 그라데이션 (subtle)
- 탭 → S08 PRO 구매 화면
- PRO 구매 완료 시 이 배너 숨김

### 패턴 C: 워터마크 (공유 카드)

```
┌─────────────────────┐
│                     │
│    [카드 콘텐츠]     │
│                     │
│        DayCount     │  ← 우하단 12pt, SemiBold, 흰색 50%
└─────────────────────┘
```

- 무료 유저: 공유 카드에 "DayCount" 워터마크 자동 표시
- PRO 유저: 워터마크 제거
- `showWatermark: !isPro` 로 제어

---

## 5. 업셀 동선 맵

### 자연스러운 업셀 포인트 (유저 행동 기반)

```
1. D-Day 생성 중 테마 선택
   → 예쁜 프리미엄 테마 발견 → PRO 뱃지 탭 → S08

2. 공유 카드 만들 때 프리미엄 템플릿 발견
   → 더 예쁜 카드 만들고 싶음 → PRO 뱃지 탭 → S08

3. 공유 카드에서 배경 사진 탭
   → 📸 사진 배경 써보고 싶음 → S08

4. 공유 카드에서 프리미엄 폰트 탭
   → 예쁜 폰트 써보고 싶음 → PRO 뱃지 탭 → S08

5. 공유 카드에 워터마크 보임
   → 깔끔한 카드 만들고 싶음 → S08

6. 설정 화면 방문
   → PRO 배너 → S08
```

### 업셀 원칙

1. **방해하지 않기** — 팝업, 강제 모달 없음
2. **보여주기** — 잠긴 콘텐츠의 미리보기를 보여줘서 "갖고 싶다" 유도
3. **데이터 잠금 아님** — 모든 D-Day 데이터는 무료, 꾸미기만 유료
4. **한 번만 결제** — 구독 피로 없음, "영구 해금" 강조

---

## 6. 구매 플로우 상세

### 정상 플로우

```
1. S08 PRO 화면 진입
2. "Unlock DayCount PRO" 버튼 탭
3. → RevenueCat purchasePackage() 호출
4. → 네이티브 결제 시트 (Apple/Google) 표시
5. → 유저 결제 완료
6. → RevenueCat 콜백 → isPro = true
7. → settings DB 업데이트
8. → S08 화면에 "🎉 Thank you!" 표시 (1.5초)
9. → 이전 화면으로 자동 pop
10. → 잠금 해제된 상태로 돌아감
```

### 구매 성공 후 UI 변경

| 화면 | 변경 사항 |
|------|----------|
| S03 테마 선택 | PRO 뱃지 제거, 모든 테마 선택 가능 |
| S06 공유 카드 | PRO 뱃지 제거, 모든 템플릿/폰트 선택 가능, 사진 배경 사용 가능, 워터마크 제거 |
| S07 설정 | PRO 배너 숨김 |
| S08 PRO | "Already PRO! ✨" 상태 표시 (재진입 시) |

### 구매 취소

```
유저가 결제 시트에서 취소
→ RevenueCat에서 userCancelled 에러
→ 아무것도 하지 않음 (S08 화면 유지)
→ 유저가 다시 시도하거나 뒤로가기 가능
```

---

## 7. 복원 플로우

### 정상 복원

```
1. S07 설정 → "Restore Purchase" 탭
   또는 S08 PRO → "Restore Purchase" 탭
2. → RevenueCat restorePurchases() 호출
3. → 로딩 인디케이터 표시
4. → 구매 내역 있음 → isPro = true
5. → SnackBar: "Purchase restored successfully! ✨"
6. → 잠금 해제
```

### 복원 실패 케이스

| 상황 | 메시지 (en) | 메시지 (ko) |
|------|------------|------------|
| 구매 내역 없음 | "No previous purchase found." | "이전 구매 내역이 없습니다." |
| 네트워크 에러 | "Network error. Please check your connection and try again." | "네트워크 오류. 연결을 확인하고 다시 시도해주세요." |
| 스토어 에러 | "Store error. Please try again later." | "스토어 오류. 잠시 후 다시 시도해주세요." |
| 알 수 없는 에러 | "Something went wrong. Please try again." | "문제가 발생했습니다. 다시 시도해주세요." |

모든 에러: SnackBar로 표시 (빨간 배경 X, 기본 배경에 텍스트만)

---

## 8. 오프라인 동작

| 상황 | 동작 |
|------|------|
| 앱 시작 (오프라인) | settings DB 캐시에서 isPro 읽기 → 마지막 알려진 상태 유지 |
| 구매 시도 (오프라인) | "인터넷 연결을 확인하세요" SnackBar |
| 복원 시도 (오프라인) | "인터넷 연결을 확인하세요" SnackBar |
| 이미 PRO인 상태 (오프라인) | 정상 동작 (로컬 캐시로 잠금 해제 유지) |

---

## 9. PRO 구매 화면 (S08) 상세

### 레이아웃

```
배경: linear-gradient(180deg, #1A1A2E 0%, #2D1B69 100%)

[← 뒤로가기]                           ← 좌상단

      👑                               ← 48pt, shimmer 애니메이션
  DayCount PRO                         ← 28pt, ExtraBold, white
  Unlock the full experience           ← 14pt, #A0A0C0

┌──────────────────────────────────┐
│  🎨  Premium Themes               │   ← 기능 카드 1
│  15+ stunning card themes          │
└──────────────────────────────────┘
┌──────────────────────────────────┐
│  📸  Photo Cards                   │   ← 기능 카드 2
│  Add your own photos to cards      │
└──────────────────────────────────┘
┌──────────────────────────────────┐
│  📤  Custom Share Cards            │   ← 기능 카드 3
│  Premium templates & fonts         │
└──────────────────────────────────┘

        $3.99                          ← 40pt, ExtraBold, white
  One-time purchase                    ← 13pt, #A0A0C0
  Forever yours

┌──────────────────────────────────┐
│       Unlock DayCount PRO         │   ← 금색 그라데이션 CTA
└──────────────────────────────────┘
       Restore Purchase              ← 13pt, #666, 텍스트 버튼
```

### 기능 카드 스타일

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.06),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.08)),
  ),
  child: Row(children: [
    // 아이콘 컨테이너 (44x44, 프라이머리 20% opacity, radius 14)
    // 텍스트: 제목 15pt Bold white + 설명 12pt #A0A0C0
  ]),
)
```

### CTA 버튼

```dart
Container(
  padding: EdgeInsets.symmetric(vertical: 16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
    boxShadow: [BoxShadow(color: Color(0xFFFFD700).withOpacity(0.3), blurRadius: 24, offset: Offset(0, 8))],
  ),
  child: Text("Unlock DayCount PRO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
)
```

### 이미 PRO인 경우

```
      ✨
  You're already PRO!
  All features are unlocked.

  (CTA 버튼 대신 체크마크 표시)
```
