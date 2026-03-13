import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/sleep_cost_summary.dart';
import 'package:life_cost_tracker/domain/entities/display_cycle.dart';
import 'package:life_cost_tracker/domain/entities/cost_category.dart';

void main() {
  group('SleepCostSummary', () {
    test('should calculate display cost using actual calendar days', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        groupDailyCosts: {
          CostCategoryGroup.housing: 60,
          CostCategoryGroup.digitalSubscription: 25,
        },
        installmentDaily: 15,
        unpaidItems: [],
        paidItems: [],
        installmentItems: [],
      );

      // Daily is always 1
      expect(summary.displayCost(DisplayCycle.daily), 100);

      // Monthly uses actual days in current month
      final daysInMonth = DisplayCycle.monthly.actualDays;
      expect(summary.displayCost(DisplayCycle.monthly), 100.0 * daysInMonth);

      // Quarterly uses actual days in current quarter
      final daysInQuarter = DisplayCycle.quarterly.actualDays;
      expect(summary.displayCost(DisplayCycle.quarterly), 100.0 * daysInQuarter);

      // Yearly uses actual days in current year
      final daysInYear = DisplayCycle.yearly.actualDays;
      expect(summary.displayCost(DisplayCycle.yearly), 100.0 * daysInYear);
    });

    test('should calculate group percentages correctly', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        groupDailyCosts: {
          CostCategoryGroup.housing: 60,
          CostCategoryGroup.digitalSubscription: 25,
        },
        installmentDaily: 15,
        unpaidItems: [],
        paidItems: [],
        installmentItems: [],
      );

      expect(summary.groupPercentage(CostCategoryGroup.housing), 0.6);
      expect(summary.groupPercentage(CostCategoryGroup.digitalSubscription), 0.25);
      expect(summary.installmentPercentage, 0.15);
      expect(summary.groupPercentage(CostCategoryGroup.other), 0);
    });

    test('should handle zero total daily cost', () {
      expect(SleepCostSummary.empty.groupPercentage(CostCategoryGroup.housing), 0);
      expect(SleepCostSummary.empty.installmentPercentage, 0);
      expect(SleepCostSummary.empty.totalItemCount, 0);
    });

    test('should return active groups sorted by cost descending', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        groupDailyCosts: {
          CostCategoryGroup.digitalSubscription: 25,
          CostCategoryGroup.housing: 60,
          CostCategoryGroup.living: 15,
        },
        installmentDaily: 0,
        unpaidItems: [],
        paidItems: [],
        installmentItems: [],
      );

      final groups = summary.activeGroups;
      expect(groups.length, 3);
      expect(groups[0], CostCategoryGroup.housing);
      expect(groups[1], CostCategoryGroup.digitalSubscription);
      expect(groups[2], CostCategoryGroup.living);
    });
  });
}
