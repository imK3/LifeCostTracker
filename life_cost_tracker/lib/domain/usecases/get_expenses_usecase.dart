// get_expenses_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'base_usecase.dart';

/// Get expenses use case
/// 获取支出列表用例
class GetExpensesUseCase implements BaseUseCase<List<Expense>, NoParams> {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository repository;

  /// Constructor
  /// 构造函数
  GetExpensesUseCase(this.repository);

  /// Execute the use case
  /// 执行用例
  @override
  Future<List<Expense>> call(NoParams params) async {
    return await repository.getExpenses();
  }
}