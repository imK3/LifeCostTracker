// get_expenses_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'base_usecase.dart';

class GetExpensesUseCase implements BaseUseCase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  @override
  Future<List<Expense>> call(NoParams params) async {
    return await repository.getExpenses();
  }
}
