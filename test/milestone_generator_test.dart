import 'package:flutter_test/flutter_test.dart';

import 'package:daycount/core/utils/milestone_generator.dart';

void main() {
  group('generateMilestones', () {
    group('general category', () {
      test('generates correct milestones', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'general',
        );

        final days = milestones.map((m) => m.days).toList();
        expect(days, [100, 200, 365, 500, 730, 1000, 1095]);
      });

      test('all milestones have ddayId set', () {
        final milestones = generateMilestones(
          ddayId: 42,
          category: 'general',
        );

        for (final m in milestones) {
          expect(m.ddayId, 42);
        }
      });

      test('all milestones are not custom', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'general',
        );

        for (final m in milestones) {
          expect(m.isCustom, false);
        }
      });

      test('generates correct labels', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'general',
        );

        final labels = {for (final m in milestones) m.days: m.label};
        expect(labels[100], '100 Days');
        expect(labels[200], '200 Days');
        expect(labels[365], '1 Year');
        expect(labels[500], '500 Days');
        expect(labels[730], '2 Years');
        expect(labels[1000], '1000 Days');
        expect(labels[1095], '3 Years');
      });
    });

    group('couple category', () {
      test('generates 100-day intervals plus yearly', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'couple',
        );

        final days = milestones.map((m) => m.days).toList();

        // 100-day intervals
        expect(days.contains(100), true);
        expect(days.contains(200), true);
        expect(days.contains(300), true);
        expect(days.contains(400), true);
        expect(days.contains(500), true);
        expect(days.contains(1000), true);

        // Yearly
        expect(days.contains(365), true);
        expect(days.contains(730), true);
        expect(days.contains(1095), true);
      });

      test('no duplicate days', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'couple',
        );

        final days = milestones.map((m) => m.days).toList();
        expect(days.length, days.toSet().length);
      });

      test('days are sorted ascending', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'couple',
        );

        final days = milestones.map((m) => m.days).toList();
        for (int i = 1; i < days.length; i++) {
          expect(days[i] > days[i - 1], true);
        }
      });
    });

    group('exam category', () {
      test('generates correct milestones', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'exam',
        );

        final days = milestones.map((m) => m.days).toList();
        expect(days, [30, 60, 90, 100, 200, 365]);
      });

      test('generates correct labels for monthly milestones', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'exam',
        );

        final labels = {for (final m in milestones) m.days: m.label};
        expect(labels[30], '1 Month');
        expect(labels[60], '2 Months');
        expect(labels[90], '3 Months');
        expect(labels[100], '100 Days');
        expect(labels[365], '1 Year');
      });
    });

    group('baby category', () {
      test('generates monthly intervals plus standard milestones', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'baby',
        );

        final days = milestones.map((m) => m.days).toList();

        // Monthly intervals
        expect(days.contains(30), true);
        expect(days.contains(60), true);
        expect(days.contains(90), true);
        expect(days.contains(120), true);
        expect(days.contains(360), true);

        // Standard milestones
        expect(days.contains(100), true);
        expect(days.contains(200), true);
        expect(days.contains(365), true);
        expect(days.contains(730), true);
      });

      test('no duplicate days', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'baby',
        );

        final days = milestones.map((m) => m.days).toList();
        expect(days.length, days.toSet().length);
      });

      test('monthly labels are correct', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'baby',
        );

        final labels = {for (final m in milestones) m.days: m.label};
        expect(labels[30], '1 Month');
        expect(labels[180], '6 Months');
        expect(labels[360], '12 Months');
      });
    });

    group('unknown category', () {
      test('falls back to general milestones', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'unknown',
        );

        final days = milestones.map((m) => m.days).toList();
        expect(days, [100, 200, 365, 500, 730, 1000, 1095]);
      });
    });

    group('default notifyBefore', () {
      test('all milestones have default notifyBefore', () {
        final milestones = generateMilestones(
          ddayId: 1,
          category: 'general',
        );

        for (final m in milestones) {
          expect(m.notifyBefore, ['7d', '3d', '0d']);
        }
      });
    });
  });
}
