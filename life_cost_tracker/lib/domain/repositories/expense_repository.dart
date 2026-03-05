// expense_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
