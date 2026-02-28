# DayCount — Date Calculation Rules

---

## 1. 기본 일수 계산

### 카운트다운 (미래 날짜)

```dart
// targetDate가 오늘 이후
int daysLeft = targetDate.difference(today).inDays;
// 결과: 양수 → "N days left"
```

### 카운트업 (과거 날짜)

```dart
// targetDate가 오늘 이전
int daysSince = today.difference(targetDate).inDays;
// 결과: 양수 → "+N days ago" 또는 "+N days since"
```

### D-Day 당일 (오늘)

```dart
// targetDate == today
// 결과: 0 → "D-Day!" 또는 "Today!"
```

### 자동 판별

```dart
bool get isCountUp => targetDate.isBefore(today) || targetDate.isAtSameMomentAs(today);
```

- isCountUp은 DB에 저장하지만, 실제로는 매번 계산으로 판별해도 됨
- targetDate == today인 경우도 "D-Day 도달"로 처리

---

## 2. "오늘" 기준

```dart
DateTime get today {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day); // 시간 제거, 자정 기준
}
```

- **항상 로컬 타임존 기준**
- 시간/분/초는 제거하고 날짜만 비교
- 자정 직전/직후 문제 방지: DateTime.now()에서 시간 부분을 00:00:00으로 고정

---

## 3. 주/월 환산

### 주 환산

```dart
int weeks = totalDays ~/ 7;
int remainingDays = totalDays % 7;
// 표시: "89 weeks" (상세 화면 서브 카운트)
```

### 월 환산

```dart
int months = totalDays ~/ 30;
// 표시: "20 months" (상세 화면 서브 카운트)
// 참고: 정확한 달력 기반이 아닌 30일 = 1개월 근사치
```

### 육아 모드 개월수 (정확한 달력 기반)

```dart
// baby 카테고리에서만 정확한 개월수 계산
int monthsSince(DateTime birthDate, DateTime today) {
  int months = (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
  if (today.day < birthDate.day) months--;
  return months;
}

int remainingDays(DateTime birthDate, DateTime today) {
  // 이번 달 기준일에서 오늘까지의 일수
  DateTime thisMonthAnniversary = DateTime(today.year, today.month, birthDate.day);
  if (today.day < birthDate.day) {
    thisMonthAnniversary = DateTime(today.year, today.month - 1, birthDate.day);
  }
  return today.difference(thisMonthAnniversary).inDays;
}

// 표시: "8개월 15일" / "8 months 15 days"
```

---

## 4. 마일스톤 도달 판정

```dart
bool isMilestoneReached(DateTime targetDate, int milestoneDays, DateTime today) {
  int daysSinceTarget = today.difference(targetDate).inDays;
  return daysSinceTarget >= milestoneDays;
}
```

- targetDate부터 milestoneDays일 경과 여부로 판정
- 카운트다운(미래 날짜)의 마일스톤: 해당 없음 (D-Day 도달 후부터 마일스톤 카운트)
- **예외**: exam 카테고리는 카운트다운 전용이므로, D-Day까지 남은 일수 기준 마일스톤
  - exam의 마일스톤 30, 60, 90 등은 "D-Day까지 N일 남았을 때" 도달

### Exam 카테고리 마일스톤 특수 처리

```dart
// exam의 경우: 남은 일수가 마일스톤과 같거나 작을 때 도달
bool isExamMilestoneReached(DateTime examDate, int milestoneDays, DateTime today) {
  int daysLeft = examDate.difference(today).inDays;
  return daysLeft <= milestoneDays;
}
// 예: 시험 D-90 → 시험까지 90일 남았을 때 도달
```

---

## 5. 마일스톤 날짜 계산

### 일반/커플/육아 (카운트업 기준)

```dart
DateTime milestoneDate(DateTime targetDate, int milestoneDays) {
  return targetDate.add(Duration(days: milestoneDays));
}
// 예: targetDate=2024-06-15, 100일 → 2024-09-23
```

### 시험 (카운트다운 기준)

```dart
DateTime examMilestoneDate(DateTime examDate, int milestoneDays) {
  return examDate.subtract(Duration(days: milestoneDays));
}
// 예: examDate=2026-06-20, D-90 → 2026-03-22
```

---

## 6. 알림 날짜 계산

```dart
DateTime notificationDate(DateTime milestoneDate, String notifyBefore) {
  switch (notifyBefore) {
    case "7d": return milestoneDate.subtract(Duration(days: 7));
    case "3d": return milestoneDate.subtract(Duration(days: 3));
    case "0d": return milestoneDate; // 당일
  }
}

// 알림 시간: 오전 9:00 로컬
DateTime notificationDateTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 9, 0, 0);
}
```

- 알림 날짜가 과거면 스케줄링 스킵
- 알림 날짜가 오늘이면 즉시 스케줄링 (9시 이전이면 오늘 9시, 이후면 스킵)

---

## 7. 정렬 로직

| 정렬 옵션 | 정렬 기준 | 방향 |
|-----------|----------|------|
| `date_asc` | targetDate | 가까운 미래 먼저 → 먼 미래 → 최근 과거 → 먼 과거 |
| `date_desc` | targetDate | 먼 미래 먼저 → 가까운 미래 → 먼 과거 → 최근 과거 |
| `created` | createdAt | 최근 생성 먼저 (내림차순) |
| `manual` | sortOrder | sortOrder 오름차순 |

### date_asc 상세 (기본 정렬)

"가장 임박한 이벤트가 위에" 원칙:

```dart
list.sort((a, b) {
  int daysA = a.targetDate.difference(today).inDays;
  int daysB = b.targetDate.difference(today).inDays;

  // 미래 이벤트 먼저 (양수), 과거 이벤트 나중 (음수)
  if (daysA >= 0 && daysB >= 0) return daysA.compareTo(daysB); // 둘 다 미래: 가까운순
  if (daysA < 0 && daysB < 0) return daysB.compareTo(daysA);   // 둘 다 과거: 최근순
  if (daysA >= 0) return -1; // a 미래, b 과거 → a 먼저
  return 1;                   // a 과거, b 미래 → b 먼저
});
```

---

## 8. 윤년 처리

Dart의 `DateTime`과 `Duration`이 자동으로 처리.

```dart
// 2024-02-29 + 365일 = 2025-02-28 (자동)
DateTime(2024, 2, 29).add(Duration(days: 365)); // 2025-02-28
```

별도 윤년 로직 불필요. Dart 표준 라이브러리에 위임.

---

## 9. 시간대 처리

- 모든 날짜는 **로컬 타임존** 기준
- DB 저장: ISO 8601 날짜 문자열 ("2026-03-28") — 시간 없음
- `DateTime.parse()`로 읽을 때 로컬로 해석됨
- 시간대 변환 로직 불필요 (서버 없음, 기기 로컬 시간만 사용)

---

## 10. 엣지케이스 정리

| 케이스 | 처리 |
|--------|------|
| D-Day가 오늘 | 일수 = 0, "D-Day!" 또는 "Today!" 표시 |
| 아주 먼 과거 (1990-01-01) | 정상 계산 (13,000일+ 표시) |
| 아주 먼 미래 (2090-01-01) | 정상 계산 (23,000일+ 표시) |
| 100개+ D-Day | ListView.builder로 lazy 렌더링 → 성능 문제 없음 |
| 같은 날짜 D-Day 여러 개 | 허용, 정렬 시 createdAt으로 2차 정렬 |
| 2월 29일 생성 D-Day | Dart DateTime이 자동 처리 |
| 자정 전후 | today를 자정 기준으로 고정하므로 문제 없음 |
| 기기 시간 변경 | 앱 포그라운드 복귀 시 Provider 리프레시로 일수 재계산 |
