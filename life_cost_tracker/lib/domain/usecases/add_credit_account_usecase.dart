// add_credit_account_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';
import '../repositories/credit_account_repository.dart';
import 'base_usecase.dart';

class AddCreditAccountUseCase implements BaseUseCase<void, CreditAccount> {
  final CreditAccountRepository repository;

  AddCreditAccountUseCase(this.repository);

  @override
  Future<void> call(CreditAccount account) async {
    await repository.addCreditAccount(account);
  }
}
