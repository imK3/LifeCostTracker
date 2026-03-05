// expense_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/expense.dart';
import 'package:life_cost_tracker/domain/entities/expense_category.dart';

void main() {
  group('Expense Entity Tests (支出实体测试)', () {
    test('should create an Expense with default values (应该使用默认值创建支出)', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.food,
      );

      // Verify that all properties have correct default values
      // 验证所有属性是否具有正确的默认值
      expect(expense.id, isNotNull);
      expect(expense.amount, 100.0);
      expect(expense.category, ExpenseCategory.food);
      expect(expense.date, isNotNull);
      expect(expense.notes, isNull);
      expect(expense.receiptPhotoUrl, isNull);
      expect(expense.estimatedUsageDays, isNull);
      expect(expense.dailyCost, isNull);
    });

    test('should calculate dailyCost when estimatedUsageDays is provided (当提供预计使用天数时，应该计算每日成本)', () {
      final expense = Expense(
        amount: 365.0,
        category: ExpenseCategory.shopping,
        estimatedUsageDays: 365,
      );

      // 365 amount / 365 days = 1.0 daily cost
      // 365 总金额 / 365 天 = 1.0 每日成本
      expect(expense.dailyCost, 1.0);
    });

    test('should return null for dailyCost when estimatedUsageDays is zero (当预计使用天数为零时，每日成本应返回 null)', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.entertainment,
        estimatedUsageDays: 0,
      );

      expect(expense.dailyCost, isNull);
    });

    test('should return null for dailyCost when estimatedUsageDays is negative (当预计使用天数为负数时，每日成本应返回 null)', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.transport,
        estimatedUsageDays: -10,
      );

      expect(expense.dailyCost, isNull);
    });

    test('should create a copy with updated values using copyWith (应该使用 copyWith 创建包含更新值的副本)', () {
      final original = Expense(
        amount: 100.0,
        category: ExpenseCategory.food,
        notes: 'Original note',
      );

      final updated = original.copyWith(
        amount: 200.0,
        category: ExpenseCategory.shopping,
        notes: 'Updated note',
      );

      // Verify that specified values are updated and others remain the same
      // 验证指定的值已更新，其他值保持不变
      expect(updated.id, original.id);
      expect(updated.amount, 200.0);
      expect(updated.category, ExpenseCategory.shopping);
      expect(updated.notes, 'Updated note');
    });

    test('should convert to and from JSON correctly (应该正确地与 JSON 进行相互转换)', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.food,
        notes: 'Test note',
        estimatedUsageDays: 10,
      );

      final json = expense.toJson();
      final fromJson = Expense.fromJson(json);

      // Verify that object created from JSON matches the original
      // 验证从 JSON 创建的对象与原始对象一致
      expect(fromJson.id, expense.id);
      expect(fromJson.amount, expense.amount);
      expect(fromJson.category, expense.category);
      expect(fromJson.notes, expense.notes);
      expect(fromJson.estimatedUsageDays, expense.estimatedUsageDays);
    });
  });
}
