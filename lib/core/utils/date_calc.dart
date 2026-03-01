// Date calculation utilities for DayCount.
// Rules defined in docs/date-rules.md.

/// Returns today at midnight (local timezone, time stripped).
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Calculates days difference: positive = future, negative = past, 0 = today.
int daysDiff(DateTime targetDate, DateTime todayDate) {
  final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
  final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
  return target.difference(today).inDays;
}

/// Week conversion: totalDays ÷ 7.
int toWeeks(int totalDays) => totalDays.abs() ~/ 7;

/// Remaining days after week conversion.
int remainingDaysAfterWeeks(int totalDays) => totalDays.abs() % 7;

/// Month conversion (approximate, 30 days = 1 month).
int toMonths(int totalDays) => totalDays.abs() ~/ 30;

/// Calendar-based month calculation for baby category.
/// Returns the exact number of full calendar months since [birthDate].
int monthsSince(DateTime birthDate, DateTime todayDate) {
  int months =
      (todayDate.year - birthDate.year) * 12 + (todayDate.month - birthDate.month);
  if (todayDate.day < birthDate.day) months--;
  if (months < 0) months = 0;
  return months;
}

/// Remaining days within the current month period for baby age.
int babyRemainingDays(DateTime birthDate, DateTime todayDate) {
  int days;
  if (todayDate.day >= birthDate.day) {
    days = todayDate.day - birthDate.day;
  } else {
    final prevMonthDate =
        DateTime(todayDate.year, todayDate.month - 1, birthDate.day);
    days = todayDate.difference(prevMonthDate).inDays;
  }
  if (days < 0) days = 0;
  return days;
}

/// Whether a milestone is reached for general/couple/baby categories.
/// [daysSinceTarget] = today.difference(targetDate).inDays
bool isMilestoneReached(int daysSinceTarget, int milestoneDays) {
  return daysSinceTarget >= milestoneDays;
}

/// Whether a milestone is reached for exam category.
/// [daysLeft] = examDate.difference(today).inDays
bool isExamMilestoneReached(int daysLeft, int milestoneDays) {
  return daysLeft <= milestoneDays;
}

/// Milestone date for general/couple/baby (count-up).
DateTime milestoneDate(DateTime targetDate, int milestoneDays) {
  return targetDate.add(Duration(days: milestoneDays));
}

/// Milestone date for exam (countdown).
DateTime examMilestoneDate(DateTime examDate, int milestoneDays) {
  return examDate.subtract(Duration(days: milestoneDays));
}
