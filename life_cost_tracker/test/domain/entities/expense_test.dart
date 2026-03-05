// expense_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/expense.dart';
import 'package:life_cost_tracker/domain/entities/expense_category.dart';

void main() {
  group('Expense Entity Tests', () {
    test('should create an Expense with default values', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.food,
      );

      expect(expense.id, isNotNull);
      expect(expense.amount, 100.0);
      expect(expense.category, ExpenseCategory.food);
      expect(expense.date, isNotNull);
      expect(expense.notes, isNull);
      expect(expense.receiptPhotoUrl, isNull);
      expect(expense.estimatedUsageDays, isNull);
      expect(expense.dailyCost, isNull);
    });

    test('should calculate dailyCost when estimatedUsageDays is provided', () {
      final expense = Expense(
        amount: 365.0,
        category: ExpenseCategory.shopping,
        estimatedUsageDays: 365,
      );

      expect(expense.dailyCost, 1.0);
    });

    test('should return null for dailyCost when estimatedUsageDays is zero', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.entertainment,
        estimatedUsageDays: 0,
      );

      expect(expense.dailyCost, isNull);
    });

    test('should return null for dailyCost when estimatedUsageDays is negative', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.transport,
        estimatedUsageDays: -10,
      );

      expect(expense.dailyCost, isNull);
    });

    test('should create a copy with updated values using copyWith', () {
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

      expect(updated.id, original.id);
      expect(updated.amount, 200.0);
      expect(updated.category, ExpenseCategory.shopping);
      expect(updated.notes, 'Updated note');
    });

    test('should convert to and from JSON correctly', () {
      final expense = Expense(
        amount: 100.0,
        category: ExpenseCategory.food,
        notes: 'Test note',
        estimatedUsageDays: 10,
      );

      final json = expense.toJson();
      final fromJson = Expense.fromJson(json);

      expect(fromJson.id, expense.id);
      expect(fromJson.amount, expense.amount);
      expect(fromJson.category, expense.category);
      expect(fromJson.notes, expense.notes);
      expect(fromJson.estimatedUsageDays, expense.estimatedUsageDays);
    });
  });
}
