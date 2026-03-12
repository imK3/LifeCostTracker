import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/affordability_item.dart';

void main() {
  group('AffordabilityItem', () {
    test('should calculate daily impact for installment', () {
      final item = AffordabilityItem(
        name: 'iPhone 16',
        totalCost: 9000,
        isInstallment: true,
        installmentPeriods: 12,
        monthlyPayment: 750,
      );

      expect(item.dailyImpact, 25.0);
      expect(item.monthlyImpact, 750.0);
    });

    test('should return 0 daily impact for one-time purchase', () {
      final item = AffordabilityItem(
        name: '新键盘',
        totalCost: 500,
        isInstallment: false,
      );

      expect(item.dailyImpact, 0);
      expect(item.monthlyImpact, 0);
    });

    test('should auto-calculate monthly payment if not specified', () {
      final item = AffordabilityItem(
        name: 'Test',
        totalCost: 12000,
        isInstallment: true,
        installmentPeriods: 12,
      );

      // dailyImpact uses monthlyPayment ?? (totalCost / periods)
      expect(item.dailyImpact, closeTo(33.33, 0.01));
    });

    test('should serialize and deserialize JSON', () {
      final item = AffordabilityItem(
        id: 'test-id',
        name: 'PS5',
        totalCost: 3999,
        isInstallment: true,
        installmentPeriods: 6,
        monthlyPayment: 666.5,
        notes: '想买很久了',
      );

      final json = item.toJson();
      final restored = AffordabilityItem.fromJson(json);

      expect(restored.id, 'test-id');
      expect(restored.name, 'PS5');
      expect(restored.totalCost, 3999);
      expect(restored.isInstallment, true);
      expect(restored.installmentPeriods, 6);
      expect(restored.notes, '想买很久了');
    });
  });
}
