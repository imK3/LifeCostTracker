// calculate_credit_utilization_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';
import '../repositories/credit_account_repository.dart';
import 'base_usecase.dart';

class CalculateCreditUtilizationUseCase implements BaseUseCase<double?, NoParams> {
  final CreditAccountRepository repository;

  CalculateCreditUtilizationUseCase(this.repository);

  @override
  Future<double?> call(NoParams params) async {
    final accounts = await repository.getCreditAccounts();
    if (accounts.isEmpty) return null;

    double totalBalance = 0;
    double totalCreditLimit = 0;

    for (final account in accounts) {
      totalBalance += account.balance;
      if (account.creditLimit != null) {
        totalCreditLimit += account.creditLimit!;
      }
    }

    if (totalCreditLimit <= 0) return null;
    return totalBalance / totalCreditLimit;
  }
}
