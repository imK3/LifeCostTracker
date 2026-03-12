import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/sleep_cost_summary.dart';
import 'package:life_cost_tracker/domain/entities/display_cycle.dart';

void main() {
  group('SleepCostSummary', () {
    test('should calculate display cost for different cycles', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        fixedLivingDaily: 60,
        subscriptionDaily: 25,
        installmentDaily: 15,
        fixedLivingItems: [],
        subscriptionItems: [],
        installmentItems: [],
      );

      expect(summary.displayCost(DisplayCycle.daily), 100);
      expect(summary.displayCost(DisplayCycle.monthly), 3000);
      expect(summary.displayCost(DisplayCycle.yearly), 36500);
    });

    test('should calculate percentages correctly', () {
      const summary = SleepCostSummary(
        totalDailyCost: 100,
        fixedLivingDaily: 60,
        subscriptionDaily: 25,
        installmentDaily: 15,
        fixedLivingItems: [],
        subscriptionItems: [],
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
