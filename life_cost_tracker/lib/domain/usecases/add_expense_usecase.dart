// add_expense_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'base_usecase.dart';

class AddExpenseUseCase implements BaseUseCase<void, Expense> {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  @override
  Future<void> call(Expense expense) async {
    await repository.addExpense(expense);
  }
}
