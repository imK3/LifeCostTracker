import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/recurring_cost.dart';
import 'package:life_cost_tracker/domain/entities/billing_cycle.dart';
import 'package:life_cost_tracker/domain/entities/cost_category.dart';
// CostCategoryGroup is exported from cost_category.dart

void main() {
  group('RecurringCost', () {
    test('should calculate daily cost using actual calendar days', () {
      final cost = RecurringCost(
        name: '房租',
        amount: 3000,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      final daysInMonth = BillingCycle.monthly.daysInCycle;
      expect(cost.dailyCost, 3000.0 / daysInMonth);
    });

    test('should calculate daily cost for yearly billing', () {
      final cost = RecurringCost(
        name: '保险',
        amount: 3650,
        billingCycle: BillingCycle.yearly,
        category: CostCategory.insurance,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2027, 1, 1),
      );

      final daysInYear = BillingCycle.yearly.daysInCycle;
      expect(cost.dailyCost, 3650.0 / daysInYear);
    });

    test('should calculate daily cost for quarterly billing', () {
      final cost = RecurringCost(
        name: '季度报刊',
        amount: 900,
        billingCycle: BillingCycle.quarterly,
        category: CostCategory.other,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 4, 1),
      );

      final daysInQuarter = BillingCycle.quarterly.daysInCycle;
      expect(cost.dailyCost, 900.0 / daysInQuarter);
    });

    test('should calculate daily cost for weekly billing', () {
      final cost = RecurringCost(
        name: '每周买菜',
        amount: 350,
        billingCycle: BillingCycle.weekly,
        category: CostCategory.groceries,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 1, 8),
      );

      // Weekly is always 7 days
      expect(cost.dailyCost, 50.0);
    });

    test('should correctly identify category group', () {
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

      expect(rent.group, CostCategoryGroup.housing);
      expect(claude.group, CostCategoryGroup.digitalSubscription);
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

      final daysInMonth = BillingCycle.monthly.daysInCycle;
      final daily = 300.0 / daysInMonth;
      expect(cost.monthlyCost, daily * 30);
      expect(cost.yearlyCost, daily * 365);
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
      expect(restored.basePeriod, BillingCycle.monthly);
      expect(restored.billingCycle, BillingCycle.monthly);
      expect(restored.category, CostCategory.utilities);
      expect(restored.notes, '含燃气费');
    });

    test('dual-cycle: monthly base + quarterly billing', () {
      // 月租4500，季度付
      final cost = RecurringCost(
        name: '房租',
        amount: 4500,
        basePeriod: BillingCycle.monthly,
        billingCycle: BillingCycle.quarterly,
        category: CostCategory.rent,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 4, 1),
      );

      // dailyCost 基于 basePeriod（月）
      final daysInMonth = BillingCycle.monthly.daysInCycle;
      expect(cost.dailyCost, 4500.0 / daysInMonth);

      // paymentAmount = 4500 × (季度天数/月天数) ≈ 13500
      final daysInQuarter = BillingCycle.quarterly.daysInCycle;
      expect(cost.paymentAmount, 4500.0 * daysInQuarter / daysInMonth);
    });

    test('dual-cycle: basePeriod defaults to billingCycle when not specified', () {
      final cost = RecurringCost(
        name: '话费',
        amount: 59,
        billingCycle: BillingCycle.monthly,
        category: CostCategory.other,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2026, 2, 1),
      );

      expect(cost.basePeriod, BillingCycle.monthly);
      expect(cost.paymentAmount, 59.0);
    });

    test('dual-cycle: monthly base + yearly billing', () {
      // 保险500/月，年付
      final cost = RecurringCost(
        name: '保险',
        amount: 500,
        basePeriod: BillingCycle.monthly,
        billingCycle: BillingCycle.yearly,
        category: CostCategory.insurance,
        startDate: DateTime(2026, 1, 1),
        nextDueDate: DateTime(2027, 1, 1),
      );

      final daysInMonth = BillingCycle.monthly.daysInCycle;
      final daysInYear = BillingCycle.yearly.daysInCycle;
      expect(cost.dailyCost, 500.0 / daysInMonth);
      expect(cost.paymentAmount, 500.0 * daysInYear / daysInMonth);
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
