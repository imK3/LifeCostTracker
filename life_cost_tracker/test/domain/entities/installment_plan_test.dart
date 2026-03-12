import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/installment_plan.dart';

void main() {
  group('InstallmentPlan', () {
    test('should calculate daily cost correctly', () {
      final plan = InstallmentPlan(
        name: 'iPhone 分期',
        totalAmount: 9999,
        totalPeriods: 12,
        paidPeriods: 0,
        monthlyPayment: 833.25,
        startDate: DateTime(2026, 1, 1),
      );

      expect(plan.dailyCost, closeTo(27.78, 0.01));
    });

    test('should calculate remaining amount correctly', () {
      final plan = InstallmentPlan(
        name: 'iPhone 分期',
        totalAmount: 9999,
        totalPeriods: 12,
        paidPeriods: 4,
        monthlyPayment: 833.25,
        startDate: DateTime(2026, 1, 1),
      );

      expect(plan.remainingAmount, closeTo(6666.0, 0.1));
      expect(plan.remainingPeriods, 8);
    });

    test('should report completion status', () {
      final incomplete = InstallmentPlan(
        name: 'Test',
        totalAmount: 1000,
        totalPeriods: 10,
        paidPeriods: 5,
        monthlyPayment: 100,
        startDate: DateTime(2026, 1, 1),
      );

      final complete = InstallmentPlan(
        name: 'Test',
        totalAmount: 1000,
        totalPeriods: 10,
        paidPeriods: 10,
        monthlyPayment: 100,
        startDate: DateTime(2026, 1, 1),
      );

      expect(incomplete.isCompleted, false);
      expect(incomplete.progress, 0.5);
      expect(complete.isCompleted, true);
      expect(complete.progress, 1.0);
    });

    test('should serialize and deserialize JSON', () {
      final plan = InstallmentPlan(
        id: 'test-id',
        name: 'MacBook 分期',
        totalAmount: 15999,
        totalPeriods: 24,
        paidPeriods: 6,
        monthlyPayment: 666.63,
        startDate: DateTime(2025, 10, 1),
        notes: '花呗分期',
      );

      final json = plan.toJson();
      final restored = InstallmentPlan.fromJson(json);

      expect(restored.id, 'test-id');
      expect(restored.name, 'MacBook 分期');
      expect(restored.totalAmount, 15999);
      expect(restored.totalPeriods, 24);
      expect(restored.paidPeriods, 6);
      expect(restored.notes, '花呗分期');
    });
  });
}
