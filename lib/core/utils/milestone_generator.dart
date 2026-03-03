import '../../data/models/milestone.dart';

/// Unified milestone days: D-100, D-50, D-30, D-10, D-7, D-3, D-1, D-Day.
///
/// All categories share the same countdown milestones.
/// Milestone date = targetDate − N days.
/// Reached when today ≥ milestoneDate.
const List<int> _milestoneDays = [100, 50, 30, 10, 7, 3, 1, 0];

/// Generates milestones for a D-Day. All categories use the same set.
List<Milestone> generateMilestones({
  required int ddayId,
  required String category,
}) {
  return _milestoneDays.map((days) {
    return Milestone(
      ddayId: ddayId,
      days: days,
      label: days == 0 ? 'D-Day' : 'D-$days',
    );
  }).toList();
}

/// Returns a display label for a milestone.
/// All milestones use "D-{days}" or "D-Day" format.
String localizedMilestoneLabel(int days) {
  if (days == 0) return 'D-Day';
  return 'D-$days';
}
