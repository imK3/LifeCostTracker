// credit_account_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/credit_account.dart';
import 'package:life_cost_tracker/domain/entities/credit_account_type.dart';

void main() {
  group('CreditAccount Entity Tests (信用账户实体测试)', () {
    test('should create a CreditAccount with default values (应该使用默认值创建信用账户)', () {
      final account = CreditAccount(
        name: 'Test Credit Card',
        type: CreditAccountType.creditCard,
        balance: 1000.0,
      );

      // Verify that all properties have correct default values
      // 验证所有属性是否具有正确的默认值
      expect(account.id, isNotNull);
      expect(account.name, 'Test Credit Card');
      expect(account.type, CreditAccountType.creditCard);
      expect(account.balance, 1000.0);
      expect(account.creditLimit, isNull);
      expect(account.apr, isNull);
      expect(account.dueDate, isNull);
      expect(account.minimumPayment, isNull);
      expect(account.creditUtilization, isNull);
    });

    test('should calculate creditUtilization when creditLimit is provided (当提供信用额度时，应该计算信用利用率)', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
        creditLimit: 2000.0,
      );

      // 500 balance / 2000 limit = 0.25 (25%) utilization
      // 500 余额 / 2000 额度 = 0.25 (25%) 利用率
      expect(account.creditUtilization, 0.25);
    });

    test('should return null for creditUtilization when creditLimit is zero (当信用额度为零时，信用利用率应返回 null)', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
        creditLimit: 0.0,
      );

      expect(account.creditUtilization, isNull);
    });

    test('should return null for creditUtilization when creditLimit is null (当信用额度为 null 时，信用利用率应返回 null)', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
      );

      expect(account.creditUtilization, isNull);
    });

    test('should create a copy with updated values using copyWith (应该使用 copyWith 创建包含更新值的副本)', () {
      final original = CreditAccount(
        name: 'Original Card',
        type: CreditAccountType.creditCard,
        balance: 1000.0,
      );

      final updated = original.copyWith(
        name: 'Updated Card',
        balance: 2000.0,
        creditLimit: 5000.0,
      );

      // Verify that specified values are updated and others remain the same
      // 验证指定的值已更新，其他值保持不变
      expect(updated.id, original.id);
      expect(updated.name, 'Updated Card');
      expect(updated.balance, 2000.0);
      expect(updated.creditLimit, 5000.0);
    });

    test('should convert to and from JSON correctly (应该正确地与 JSON 进行相互转换)', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 1000.0,
        creditLimit: 5000.0,
        apr: 18.5,
      );

      final json = account.toJson();
      final fromJson = CreditAccount.fromJson(json);

      // Verify that object created from JSON matches the original
      // 验证从 JSON 创建的对象与原始对象一致
      expect(fromJson.id, account.id);
      expect(fromJson.name, account.name);
      expect(fromJson.type, account.type);
      expect(fromJson.balance, account.balance);
      expect(fromJson.creditLimit, account.creditLimit);
      expect(fromJson.apr, account.apr);
    });
  });
}
