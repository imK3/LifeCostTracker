// hive_credit_account_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// Hive 信用账户仓库实现
// Hive Credit Account Repository Implementation

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/credit_account.dart';
import '../../domain/repositories/credit_account_repository.dart';

/// Hive implementation of CreditAccountRepository
/// 信用账户仓库的 Hive 实现
class HiveCreditAccountRepository implements CreditAccountRepository {
  /// Hive box for credit accounts
  /// 信用账户的 Hive 盒子
  final Box<CreditAccount> _creditAccountBox;

  /// Constructor
  /// 构造函数
  HiveCreditAccountRepository(this._creditAccountBox);

  /// Get all credit accounts
  /// 获取所有信用账户
  @override
  Future<List<CreditAccount>> getCreditAccounts() async {
    return _creditAccountBox.values.toList();
  }

  /// Add a new credit account
  /// 添加新信用账户
  @override
  Future<void> addCreditAccount(CreditAccount account) async {
    await _creditAccountBox.put(account.id, account);
  }

  /// Update an existing credit account
  /// 更新现有信用账户
  @override
  Future<void> updateCreditAccount(CreditAccount account) async {
    await _creditAccountBox.put(account.id, account);
  }

  /// Delete a credit account by id
  /// 根据 ID 删除信用账户
  @override
  Future<void> deleteCreditAccount(String id) async {
    await _creditAccountBox.delete(id);
  }
}
