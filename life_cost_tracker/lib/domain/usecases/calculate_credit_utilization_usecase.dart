// calculate_credit_utilization_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../repositories/credit_account_repository.dart';
import 'base_usecase.dart';

/// Calculate credit utilization use case
/// 计算信用利用率用例
class CalculateCreditUtilizationUseCase
    implements BaseUseCase<double?, NoParams> {
  /// Credit account repository
  /// 信用账户仓库
  final CreditAccountRepository creditAccountRepository;

  /// Constructor
  /// 构造函数
  CalculateCreditUtilizationUseCase({required this.creditAccountRepository});

  /// Execute the use case to calculate overall credit utilization
  /// 执行用例以计算整体信用利用率
  @override
  Future<double?> call(NoParams params) async {
    final accounts = await creditAccountRepository.getCreditAccounts();
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
