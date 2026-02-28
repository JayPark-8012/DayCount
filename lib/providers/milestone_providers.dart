import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/milestone.dart';
import '../data/repositories/milestone_repository.dart';

final milestoneRepositoryProvider = Provider<MilestoneRepository>((ref) {
  return MilestoneRepository();
});

final milestonesForDdayProvider =
    FutureProvider.family<List<Milestone>, int>((ref, ddayId) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return repository.getByDdayId(ddayId);
});
