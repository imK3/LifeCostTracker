// credit_account_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/credit_account.dart';
import 'package:life_cost_tracker/domain/entities/credit_account_type.dart';

void main() {
  group('CreditAccount Entity Tests', () {
    test('should create a CreditAccount with default values', () {
      final account = CreditAccount(
        name: 'Test Credit Card',
        type: CreditAccountType.creditCard,
        balance: 1000.0,
      );

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

    test('should calculate creditUtilization when creditLimit is provided', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
        creditLimit: 2000.0,
      );

      expect(account.creditUtilization, 0.25);
    });

    test('should return null for creditUtilization when creditLimit is zero', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
        creditLimit: 0.0,
      );

      expect(account.creditUtilization, isNull);
    });

    test('should return null for creditUtilization when creditLimit is null', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 500.0,
      );

      expect(account.creditUtilization, isNull);
    });

    test('should create a copy with updated values using copyWith', () {
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

      expect(updated.id, original.id);
      expect(updated.name, 'Updated Card');
      expect(updated.balance, 2000.0);
      expect(updated.creditLimit, 5000.0);
    });

    test('should convert to and from JSON correctly', () {
      final account = CreditAccount(
        name: 'Test Card',
        type: CreditAccountType.creditCard,
        balance: 1000.0,
        creditLimit: 5000.0,
        apr: 18.5,
      );

      final json = account.toJson();
      final fromJson = CreditAccount.fromJson(json);

      expect(fromJson.id, account.id);
      expect(fromJson.name, account.name);
      expect(fromJson.type, account.type);
      expect(fromJson.balance, account.balance);
      expect(fromJson.creditLimit, account.creditLimit);
      expect(fromJson.apr, account.apr);
    });
  });
}
