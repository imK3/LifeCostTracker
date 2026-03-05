// subscription_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/subscription.dart';
import 'package:life_cost_tracker/domain/entities/billing_cycle.dart';
import 'package:life_cost_tracker/domain/entities/subscription_category.dart';

void main() {
  group('Subscription Entity Tests', () {
    test('should create a Subscription with default values', () {
      final subscription = Subscription(
        name: 'Test Subscription',
        cost: 9.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now().add(const Duration(days: 30)),
        category: SubscriptionCategory.streaming,
      );

      expect(subscription.id, isNotNull);
      expect(subscription.name, 'Test Subscription');
      expect(subscription.cost, 9.99);
      expect(subscription.billingCycle, BillingCycle.monthly);
      expect(subscription.category, SubscriptionCategory.streaming);
      expect(subscription.isFreeTrial, false);
      expect(subscription.freeTrialEndDate, isNull);
    });

    test('should calculate dailyCost correctly for monthly billing', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 30.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      expect(subscription.dailyCost, 1.0);
    });

    test('should calculate dailyCost correctly for yearly billing', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 365.0,
        billingCycle: BillingCycle.yearly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      expect(subscription.dailyCost, 1.0);
    });

    test('should calculate dailyCost correctly for weekly billing', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 7.0,
        billingCycle: BillingCycle.weekly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      expect(subscription.dailyCost, 1.0);
    });

    test('should create a copy with updated values using copyWith', () {
      final original = Subscription(
        name: 'Original',
        cost: 9.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      final updated = original.copyWith(
        name: 'Updated',
        cost: 19.99,
      );

      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.cost, 19.99);
    });

    test('should convert to and from JSON correctly', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 9.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
        isFreeTrial: true,
      );

      final json = subscription.toJson();
      final fromJson = Subscription.fromJson(json);

      expect(fromJson.id, subscription.id);
      expect(fromJson.name, subscription.name);
      expect(fromJson.cost, subscription.cost);
      expect(fromJson.isFreeTrial, subscription.isFreeTrial);
    });
  });
}
