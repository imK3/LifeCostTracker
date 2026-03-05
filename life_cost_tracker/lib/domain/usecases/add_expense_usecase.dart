// add_expense_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'base_usecase.dart';

/// Add expense use case
/// 添加支出用例
class AddExpenseUseCase implements BaseUseCase<void, Expense> {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository repository;

  /// Constructor
  /// 构造函数
  AddExpenseUseCase(this.repository);

  /// Execute the use case
  /// 执行用例
  @override
  Future<void> call(Expense expense) async {
    await repository.addExpense(expense);
  }
}
