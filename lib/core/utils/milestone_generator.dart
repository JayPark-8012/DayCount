import '../../data/models/milestone.dart';
import '../../l10n/app_localizations.dart';

/// Generates milestones for a D-Day based on its category.
///
/// Categories and their milestone rules:
/// - general: 100, 200, 365, 500, 730, 1000, 1095 days
/// - couple: 100-day intervals (100..1000) + yearly (365, 730, 1095)
/// - exam: 30, 60, 90, 100, 200, 365 days
/// - baby: monthly (30, 60, ..., 360) + 100, 200, 365, 730 days
List<Milestone> generateMilestones({
  required int ddayId,
  required String category,
}) {
  final daysList = _daysForCategory(category);

  // Remove duplicates and sort
  final uniqueDays = daysList.toSet().toList()..sort();

  return uniqueDays.map((days) {
    return Milestone(
      ddayId: ddayId,
      days: days,
      label: _labelForDays(days),
    );
  }).toList();
}

List<int> _daysForCategory(String category) {
  switch (category) {
    case 'couple':
      return [
        // 100-day intervals
        for (int i = 1; i <= 10; i++) i * 100,
        // Yearly
        365, 730, 1095,
      ];
    case 'exam':
      return [30, 60, 90, 100, 200, 365];
    case 'baby':
      return [
        // Monthly (30-day intervals)
        for (int i = 1; i <= 12; i++) i * 30,
        // Standard milestones
        100, 200, 365, 730,
      ];
    case 'general':
    default:
      return [100, 200, 365, 500, 730, 1000, 1095];
  }
}

String _labelForDays(int days) {
  if (days == 365) return '1 Year';
  if (days == 730) return '2 Years';
  if (days == 1095) return '3 Years';

  if (days % 365 == 0 && days > 0) {
    final years = days ~/ 365;
    return '$years Year${years > 1 ? 's' : ''}';
  }

  if (days % 30 == 0 && days <= 360) {
    final months = days ~/ 30;
    return '$months Month${months > 1 ? 's' : ''}';
  }

  return '$days Days';
}

/// Returns a localized label for a milestone based on its [days] value.
/// Use this at display time instead of the stored [Milestone.label].
String localizedMilestoneLabel(AppLocalizations l10n, int days) {
  if (days % 365 == 0 && days > 0) {
    final years = days ~/ 365;
    return years == 1
        ? l10n.milestone_labelYear(1)
        : l10n.milestone_labelYears(years);
  }

  if (days % 30 == 0 && days <= 360) {
    final months = days ~/ 30;
    return months == 1
        ? l10n.milestone_labelMonth(1)
        : l10n.milestone_labelMonths(months);
  }

  return l10n.milestone_labelDays(days);
}
