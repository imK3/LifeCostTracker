// add_credit_account_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';
import '../repositories/credit_account_repository.dart';
import 'base_usecase.dart';

/// Add credit account use case
/// 添加信用账户用例
class AddCreditAccountUseCase implements BaseUseCase<void, CreditAccount> {
  /// Credit account repository
  /// 信用账户仓库
  final CreditAccountRepository repository;

  /// Constructor
  /// 构造函数
  AddCreditAccountUseCase(this.repository);

  /// Execute use case
  /// 执行用例
  @override
  Future<void> call(CreditAccount account) async {
    await repository.addCreditAccount(account);
  }
}
