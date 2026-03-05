// credit_account_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';

/// Credit account repository interface
/// 信用账户仓库接口
abstract class CreditAccountRepository {
  /// Get all credit accounts
  /// 获取所有信用账户
  Future<List<CreditAccount>> getCreditAccounts();

  /// Add a new credit account
  /// 添加新信用账户
  Future<void> addCreditAccount(CreditAccount account);

  /// Update an existing credit account
  /// 更新现有信用账户
  Future<void> updateCreditAccount(CreditAccount account);

  /// Delete a credit account by id
  /// 根据 ID 删除信用账户
  Future<void> deleteCreditAccount(String id);
}
