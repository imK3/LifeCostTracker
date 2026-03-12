import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/recurring_cost.dart';
import 'package:life_cost_tracker/domain/entities/billing_cycle.dart';
import 'package:life_cost_tracker/domain/entities/cost_category.dart';

void main() {
  group('RecurringCost', () {
    test('should calculate daily cost correctly for monthly billing', () {
      final cost = RecurringCost(
        name: '房租',
        amount: 3000,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      expect(cost.dailyCost, 100.0);
    });

    test('should calculate daily cost correctly for yearly billing', () {
      final cost = RecurringCost(
        name: '保险',
        amount: 3650,
        billingCycle: BillingCycle.yearly,
        category: CostCategory.insurance,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2027, 1, 1),
      );

      expect(cost.dailyCost, 10.0);
    });

    test('should calculate daily cost correctly for quarterly billing', () {
      final cost = RecurringCost(
        name: '季度报刊',
        amount: 90,
        billingCycle: BillingCycle.quarterly,
        category: CostCategory.other,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 4, 1),
      );

      expect(cost.dailyCost, 1.0);
    });

    test('should calculate daily cost correctly for weekly billing', () {
      final cost = RecurringCost(
        name: '每周买菜',
        amount: 350,
        billingCycle: BillingCycle.weekly,
        category: CostCategory.groceries,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 1, 8),
      );

      expect(cost.dailyCost, 50.0);
    });

    test('should correctly identify fixed living vs subscription', () {
      final rent = RecurringCost(
        name: '房租',
        amount: 3000,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      final claude = RecurringCost(
        name: 'Claude Code Max',
        amount: 200,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.productivity,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      expect(rent.isFixedLiving, true);
      expect(rent.isSubscription, false);
      expect(claude.isFixedLiving, false);
      expect(claude.isSubscription, true);
    });

    test('should calculate monthly and yearly equivalents', () {
      final cost = RecurringCost(
        name: '停车费',
        amount: 300,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.parking,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      expect(cost.monthlyCost, 300.0);
      expect(cost.yearlyCost, closeTo(3650.0, 0.1));
    });

    test('should support copyWith', () {
      final cost = RecurringCost(
        name: '房租',
        amount: 3000,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      final updated = cost.copyWith(amount: 3500, isActive: false);

      expect(updated.name, '房租');
      expect(updated.amount, 3500);
      expect(updated.isActive, false);
      expect(updated.id, cost.id);
    });

    test('should serialize and deserialize JSON', () {
      final cost = RecurringCost(
        id: 'test-id',
        name: '水电费',
        amount: 200,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.utilities,
        startDate: DateTime(2026, 3, 1),
        nextDueDate: DateTime(2026, 4, 1),
        notes: '含燃气费',
      );

      final json = cost.toJson();
      final restored = RecurringCost.fromJson(json);

      expect(restored.id, 'test-id');
      expect(restored.name, '水电费');
      expect(restored.amount, 200);
      expect(restored.billingCycle, BillingCycle.monthly);
      expect(restored.category, CostCategory.utilities);
      expect(restored.notes, '含燃气费');
    });

    test('should track payment status correctly', () {
      final unpaid = RecurringCost(
        name: '房租',
        amount: 3000,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      expect(unpaid.isPaidForCurrentPeriod, false);

      final paid = unpaid.markAsPaid();
      expect(paid.isPaidForCurrentPeriod, true);

      final advanced = paid.advanceToNextPeriod();
      expect(advanced.isPaidForCurrentPeriod, false);
      expect(advanced.nextDueDate, DateTime(2026, 3, 1));
    });
  });
}
