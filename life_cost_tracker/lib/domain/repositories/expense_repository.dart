// expense_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';

/// Expense repository interface
/// 支出仓库接口
abstract class ExpenseRepository {
  /// Get all expenses
  /// 获取所有支出
  Future<List<Expense>> getExpenses();

  /// Add a new expense
  /// 添加新支出
  Future<void> addExpense(Expense expense);

  /// Update an existing expense
  /// 更新现有支出
  Future<void> updateExpense(Expense expense);

  /// Delete an expense by id
  /// 根据 ID 删除支出
  Future<void> deleteExpense(String id);
}
