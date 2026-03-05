// hive_expense_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// Hive 支出仓库实现
// Hive Expense Repository Implementation

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

/// Hive implementation of ExpenseRepository
/// 支出仓库的 Hive 实现
class HiveExpenseRepository implements ExpenseRepository {
  /// Hive box for expenses
  /// 支出的 Hive 盒子
  final Box<Expense> _expenseBox;

  /// Constructor
  /// 构造函数
  HiveExpenseRepository(this._expenseBox);

  /// Get all expenses
  /// 获取所有支出
  @override
  Future<List<Expense>> getExpenses() async {
    return _expenseBox.values.toList();
  }

  /// Add a new expense
  /// 添加新支出
  @override
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  /// Update an existing expense
  /// 更新现有支出
  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  /// Delete an expense by id
  /// 根据 ID 删除支出
  @override
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }
}
