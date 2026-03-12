import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/sleep_cost_summary.dart';
import 'package:life_cost_tracker/domain/entities/display_cycle.dart';

void main() {
  group('SleepCostSummary', () {
    test('should calculate display cost using actual calendar days', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        fixedLivingDaily: 60,
        subscriptionDaily: 25,
        installmentDaily: 15,
        unpaidFixedLivingItems: [],
        unpaidSubscriptionItems: [],
        paidFixedLivingItems: [],
        paidSubscriptionItems: [],
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

    test('should calculate percentages correctly', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        fixedLivingDaily: 60,
        subscriptionDaily: 25,
        installmentDaily: 15,
        unpaidFixedLivingItems: [],
        unpaidSubscriptionItems: [],
        paidFixedLivingItems: [],
        paidSubscriptionItems: [],
        installmentItems: [],
      );

      expect(summary.fixedLivingPercentage, 0.6);
      expect(summary.subscriptionPercentage, 0.25);
      expect(summary.installmentPercentage, 0.15);
    });

    test('should handle zero total daily cost', () {
      expect(SleepCostSummary.empty.fixedLivingPercentage, 0);
      expect(SleepCostSummary.empty.subscriptionPercentage, 0);
      expect(SleepCostSummary.empty.installmentPercentage, 0);
      expect(SleepCostSummary.empty.totalItemCount, 0);
    });
  });
}
