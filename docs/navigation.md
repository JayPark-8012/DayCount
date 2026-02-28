# DayCount — Navigation Map

---

## 화면 목록

| ID | 화면 | 경로 |
|----|------|------|
| S01 | 온보딩 | `/onboarding` |
| S02 | 홈 (리스트 뷰) | `/` |
| S03 | D-Day 생성 | `/dday/create` |
| S03 | D-Day 수정 | `/dday/edit/:id` |
| S04 | D-Day 상세 | `/dday/:id` |
| S05 | 타임라인 뷰 | 홈 내부 뷰 전환 (라우트 아님) |
| S06 | 공유 카드 생성 | `/dday/:id/share` |
| S07 | 설정 | `/settings` |
| S08 | PRO 구매 | `/pro` |
| S09 | 마일스톤 축하 | 다이얼로그 (라우트 아님) |

---

## 네비게이션 맵

```
앱 시작
  │
  ├─ onboarding_done == false ──→ S01 온보딩
  │                                  │
  │                                  └─ 완료/Skip ──→ S02 홈
  │
  └─ onboarding_done == true ───→ S02 홈
                                    │
                                    ├─ 카드 탭 ──→ S04 상세
                                    │               │
                                    │               ├─ ✏️ ──→ S03 수정 ──→ ← 상세
                                    │               ├─ Share Card ──→ S06 공유 ──→ ← 상세
                                    │               └─ ← ──→ S02 홈
                                    │
                                    ├─ 뷰 토글 (📊) ──→ S05 타임라인 (홈 내부)
                                    │                     │
                                    │                     ├─ 노드 탭 ──→ S04 상세
                                    │                     └─ 뷰 토글 (📋) ──→ S02 리스트
                                    │
                                    ├─ FAB (+) ──→ S03 생성 ──→ ← 홈
                                    │
                                    ├─ ⚙️ ──→ S07 설정
                                    │          │
                                    │          ├─ PRO 배너 ──→ S08 PRO
                                    │          ├─ Restore Purchase ──→ 복원 처리
                                    │          └─ ← ──→ S02 홈
                                    │
                                    └─ (마일스톤 도달 감지) ──→ S09 축하 다이얼로그
                                                              │
                                                              ├─ Share ──→ S06 공유
                                                              └─ Dismiss ──→ S02 홈
```

---

## PRO 구매 진입점

PRO 구매 화면(S08)으로 이동하는 모든 경로:

| 진입점 | 화면 | 트리거 |
|--------|------|--------|
| 설정 PRO 배너 | S07 설정 | PRO 배너 카드 탭 |
| 잠긴 테마 | S03 생성/수정 | 프리미엄 테마 서클 탭 |
| 잠긴 카테고리 특화 | S04 상세 | "Unlock with PRO" 버튼 탭 |
| 잠긴 공유 카드 템플릿 | S06 공유 카드 | 프리미엄 템플릿 서클 탭 |

모든 경우 S08 완료 후 → 진입한 화면으로 pop (잠금 해제된 상태)

---

## 카드 인터랙션

### 홈 카드

| 제스처 | 동작 |
|--------|------|
| 탭 | S04 상세 화면 이동 |
| 롱프레스 | 컨텍스트 메뉴 표시: 수정 / 즐겨찾기 토글 / 삭제 |
| 스와이프 | 없음 (MVP) |

### 롱프레스 컨텍스트 메뉴

```
┌─────────────────┐
│ ✏️ Edit          │
│ ⭐ Favorite      │  (또는 ☆ Unfavorite)
│ 🗑️ Delete       │
└─────────────────┘
```

- 모달 바텀시트 또는 PopupMenu
- 삭제 선택 시 확인 다이얼로그 표시

### 타임라인 노드

| 제스처 | 동작 |
|--------|------|
| 탭 | S04 상세 화면 이동 |

---

## 뒤로가기 동작

| 현재 화면 | 뒤로가기 결과 |
|-----------|-------------|
| S01 온보딩 | 앱 종료 (또는 무시) |
| S02 홈 | 앱 종료 |
| S03 생성/수정 | 홈으로 pop (저장 안 된 변경사항 있으면 확인 다이얼로그) |
| S04 상세 | 홈으로 pop |
| S05 타임라인 | 홈 리스트로 전환 (pop 아님, 뷰 토글) |
| S06 공유 카드 | 상세로 pop |
| S07 설정 | 홈으로 pop |
| S08 PRO | 이전 화면으로 pop |
| S09 축하 | dismiss (다이얼로그 닫기) |

### 미저장 변경 감지 (S03)

```
"Discard changes?"
"You have unsaved changes. Are you sure you want to go back?"
[Discard] [Keep Editing]
```

---

## 알림 딥링크

알림 탭 시 앱 열림 동작:

| 알림 타입 | 동작 |
|-----------|------|
| 마일스톤 알림 (N01~N03) | 앱 열기 → 해당 D-Day 상세 화면 (S04) |
| D-Day 당일 알림 (N04) | 앱 열기 → 해당 D-Day 상세 화면 (S04) |

구현 방식:
- 알림 payload에 `ddayId` 포함
- 앱 시작 시 `flutter_local_notifications`의 `onDidReceiveNotificationResponse` 콜백
- payload에서 ddayId 추출 → Navigator.push로 상세 화면 이동

---

## 라우팅 구현

### 추천 방식: Navigator 2.0 (GoRouter) 또는 기본 Navigator

MVP에서는 기본 Navigator로 충분:

```dart
// 이동
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(ddayId: id)));

// 돌아가기
Navigator.pop(context);

// 결과 받기 (수정 후 상세 화면 갱신)
final result = await Navigator.push(...);
if (result == true) { /* 리프레시 */ }
```

라우트가 복잡하지 않으므로 GoRouter 같은 패키지는 불필요. 다만 알림 딥링크 처리를 위해 앱 시작 시 초기 라우트 결정 로직 필요.
