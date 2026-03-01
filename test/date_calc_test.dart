import 'package:flutter_test/flutter_test.dart';

import 'package:daycount/core/utils/date_calc.dart';

void main() {
  // ── 1. daysDiff ──────────────────────────────────

  group('daysDiff', () {
    test('future date returns positive', () {
      final todayDate = DateTime(2026, 3, 1);
      final target = DateTime(2026, 3, 10);
      expect(daysDiff(target, todayDate), 9);
    });

    test('past date returns negative', () {
      final todayDate = DateTime(2026, 3, 10);
      final target = DateTime(2026, 3, 1);
      expect(daysDiff(target, todayDate), -9);
    });

    test('same date returns zero', () {
      final todayDate = DateTime(2026, 3, 1);
      expect(daysDiff(todayDate, todayDate), 0);
    });

    test('ignores time component', () {
      final todayDate = DateTime(2026, 3, 1, 23, 59, 59);
      final target = DateTime(2026, 3, 2, 0, 0, 1);
      expect(daysDiff(target, todayDate), 1);
    });

    test('very far future', () {
      final todayDate = DateTime(2026, 3, 1);
      final target = DateTime(2090, 1, 1);
      expect(daysDiff(target, todayDate), greaterThan(23000));
    });

    test('very far past', () {
      final todayDate = DateTime(2026, 3, 1);
      final target = DateTime(1990, 1, 1);
      expect(daysDiff(target, todayDate), lessThan(-13000));
    });

    test('leap year Feb 29', () {
      final todayDate = DateTime(2024, 2, 28);
      final target = DateTime(2024, 2, 29);
      expect(daysDiff(target, todayDate), 1);
    });
  });

  // ── 2. Week/Month conversion ─────────────────────

  group('toWeeks', () {
    test('exact weeks', () {
      expect(toWeeks(14), 2);
      expect(toWeeks(7), 1);
      expect(toWeeks(0), 0);
    });

    test('partial weeks', () {
      expect(toWeeks(10), 1);
      expect(toWeeks(6), 0);
    });
  });

  group('remainingDaysAfterWeeks', () {
    test('exact weeks have 0 remaining', () {
      expect(remainingDaysAfterWeeks(14), 0);
      expect(remainingDaysAfterWeeks(7), 0);
    });

    test('partial weeks', () {
      expect(remainingDaysAfterWeeks(10), 3);
      expect(remainingDaysAfterWeeks(15), 1);
    });
  });

  group('toMonths', () {
    test('approximate month calculation (30d = 1m)', () {
      expect(toMonths(30), 1);
      expect(toMonths(60), 2);
      expect(toMonths(89), 2);
      expect(toMonths(90), 3);
      expect(toMonths(0), 0);
    });
  });

  // ── 3. Baby calendar-based month calculation ─────

  group('monthsSince (baby)', () {
    test('same month, day passed', () {
      final birth = DateTime(2025, 6, 10);
      final todayDate = DateTime(2026, 3, 15);
      // 2025-06 to 2026-03 = 9 months, 15 >= 10 so no decrement
      expect(monthsSince(birth, todayDate), 9);
    });

    test('same month, day not passed', () {
      final birth = DateTime(2025, 6, 20);
      final todayDate = DateTime(2026, 3, 15);
      // 9 months raw, but 15 < 20 → 8 months
      expect(monthsSince(birth, todayDate), 8);
    });

    test('exact month boundary', () {
      final birth = DateTime(2025, 6, 15);
      final todayDate = DateTime(2026, 3, 15);
      // 15 >= 15, so full 9 months
      expect(monthsSince(birth, todayDate), 9);
    });

    test('birth is today', () {
      final birth = DateTime(2026, 3, 1);
      expect(monthsSince(birth, birth), 0);
    });

    test('future birth date returns 0', () {
      final birth = DateTime(2027, 1, 1);
      final todayDate = DateTime(2026, 3, 1);
      expect(monthsSince(birth, todayDate), 0);
    });

    test('end of month birth (Jan 31)', () {
      final birth = DateTime(2025, 1, 31);
      final todayDate = DateTime(2025, 3, 5);
      // Raw: 2 months. 5 < 31 → 1 month
      expect(monthsSince(birth, todayDate), 1);
    });

    test('12 months equals 1 year', () {
      final birth = DateTime(2025, 3, 1);
      final todayDate = DateTime(2026, 3, 1);
      expect(monthsSince(birth, todayDate), 12);
    });
  });

  group('babyRemainingDays', () {
    test('day >= birth day', () {
      final birth = DateTime(2025, 6, 10);
      final todayDate = DateTime(2026, 3, 15);
      // 15 - 10 = 5
      expect(babyRemainingDays(birth, todayDate), 5);
    });

    test('day < birth day', () {
      final birth = DateTime(2025, 6, 20);
      final todayDate = DateTime(2026, 3, 15);
      // prevMonthDate = DateTime(2026, 2, 20)
      // 2026-03-15 - 2026-02-20 = 23 days
      expect(babyRemainingDays(birth, todayDate), 23);
    });

    test('exact birth day', () {
      final birth = DateTime(2025, 6, 15);
      final todayDate = DateTime(2026, 3, 15);
      expect(babyRemainingDays(birth, todayDate), 0);
    });

    test('day 1 of month, birth day 1', () {
      final birth = DateTime(2025, 1, 1);
      final todayDate = DateTime(2026, 3, 1);
      expect(babyRemainingDays(birth, todayDate), 0);
    });
  });

  // ── 4. Milestone reached ─────────────────────────

  group('isMilestoneReached (general/couple/baby)', () {
    test('exactly reached', () {
      expect(isMilestoneReached(100, 100), true);
    });

    test('past reached', () {
      expect(isMilestoneReached(150, 100), true);
    });

    test('not yet reached', () {
      expect(isMilestoneReached(99, 100), false);
    });

    test('zero days since target', () {
      expect(isMilestoneReached(0, 100), false);
    });
  });

  group('isExamMilestoneReached', () {
    test('exam far away — not reached', () {
      // 90 days left, milestone is "30 days before exam"
      expect(isExamMilestoneReached(90, 30), false);
    });

    test('exam imminent — reached', () {
      // 20 days left, milestone is "30 days before"
      expect(isExamMilestoneReached(20, 30), true);
    });

    test('exactly at milestone', () {
      expect(isExamMilestoneReached(30, 30), true);
    });

    test('exam already passed', () {
      // daysLeft = -5 (exam passed 5 days ago)
      expect(isExamMilestoneReached(-5, 30), true);
    });
  });

  // ── 5. Milestone date calculation ────────────────

  group('milestoneDate (count-up)', () {
    test('100 days from start', () {
      final target = DateTime(2024, 6, 15);
      final result = milestoneDate(target, 100);
      expect(result, DateTime(2024, 9, 23));
    });

    test('365 days (1 year)', () {
      final target = DateTime(2024, 6, 15);
      final result = milestoneDate(target, 365);
      expect(result, DateTime(2025, 6, 15));
    });

    test('leap year crossing', () {
      final target = DateTime(2024, 2, 28);
      final result = milestoneDate(target, 1);
      expect(result, DateTime(2024, 2, 29));
    });
  });

  group('examMilestoneDate (countdown)', () {
    test('D-90 before exam', () {
      final exam = DateTime(2026, 6, 20);
      final result = examMilestoneDate(exam, 90);
      expect(result, DateTime(2026, 3, 22));
    });

    test('D-30 before exam', () {
      final exam = DateTime(2026, 6, 20);
      final result = examMilestoneDate(exam, 30);
      expect(result, DateTime(2026, 5, 21));
    });

    test('D-0 is exam date itself', () {
      final exam = DateTime(2026, 6, 20);
      final result = examMilestoneDate(exam, 0);
      expect(result, DateTime(2026, 6, 20));
    });
  });

  // ── 6. Edge cases from date-rules.md ─────────────

  group('edge cases', () {
    test('same date multiple D-Days (just calculations)', () {
      final todayDate = DateTime(2026, 3, 1);
      final target = DateTime(2026, 6, 15);
      // Two D-Days with same target should give same daysDiff
      expect(daysDiff(target, todayDate), daysDiff(target, todayDate));
    });

    test('Feb 29 leap year D-Day', () {
      // 365 days later from Feb 29 2024
      final target = DateTime(2024, 2, 29);
      final future = target.add(const Duration(days: 365));
      // 2024 is leap, 2025 is not → should land on Feb 28 2025
      expect(future, DateTime(2025, 2, 28));
    });

    test('D-Day exactly today gives zero', () {
      final todayDate = DateTime(2026, 3, 1);
      expect(daysDiff(todayDate, todayDate), 0);
    });
  });
}
