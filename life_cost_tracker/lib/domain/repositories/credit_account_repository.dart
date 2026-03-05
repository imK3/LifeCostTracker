// credit_account_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';

abstract class CreditAccountRepository {
  Future<List<CreditAccount>> getCreditAccounts();
  Future<void> addCreditAccount(CreditAccount account);
  Future<void> updateCreditAccount(CreditAccount account);
  Future<void> deleteCreditAccount(String id);
}
