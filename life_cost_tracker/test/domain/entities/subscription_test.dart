// subscription_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/subscription.dart';
import 'package:life_cost_tracker/domain/entities/billing_cycle.dart';
import 'package:life_cost_tracker/domain/entities/subscription_category.dart';

void main() {
  group('Subscription Entity Tests (订阅实体测试)', () {
    test('should create a Subscription with default values (应该使用默认值创建订阅)', () {
      final subscription = Subscription(
        name: 'Test Subscription',
        cost: 9.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now().add(const Duration(days: 30)),
        category: SubscriptionCategory.streaming,
      );

      // Verify that all properties have correct default values
      // 验证所有属性是否具有正确的默认值
      expect(subscription.id, isNotNull);
      expect(subscription.name, 'Test Subscription');
      expect(subscription.cost, 9.99);
      expect(subscription.billingCycle, BillingCycle.monthly);
      expect(subscription.category, SubscriptionCategory.streaming);
      expect(subscription.isFreeTrial, false);
      expect(subscription.freeTrialEndDate, isNull);
    });

    test('should calculate dailyCost correctly for monthly billing (应该为月度账单正确计算每日成本)', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 30.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      // 30.0 amount / 30 days = 1.0 daily cost
      // 30.0 总金额 / 30 天 = 1.0 每日成本
      expect(subscription.dailyCost, 1.0);
    });

    test('should calculate dailyCost correctly for yearly billing (应该为年度账单正确计算每日成本)', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 365.0,
        billingCycle: BillingCycle.yearly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      // 365.0 amount / 365 days = 1.0 daily cost
      // 365.0 总金额 / 365 天 = 1.0 每日成本
      expect(subscription.dailyCost, 1.0);
    });

    test('should calculate dailyCost correctly for weekly billing (应该为周度账单正确计算每日成本)', () {
      final subscription = Subscription(
        name: 'Test',
        cost: 7.0,
        billingCycle: BillingCycle.weekly,
        nextBillingDate: DateTime.now(),
        category: SubscriptionCategory.streaming,
      );

      // 7.0 amount / 7 days = 1.0 daily cost
      // 7.0 总金额 / 7 天 = 1.0 每日成本
      expect(subscription.dailyCost, 1.0);
    });

    test('should create a copy with updated values using copyWith (应该使用 copyWith 创建包含更新值的副本)', () {
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

      // Verify that specified values are updated and others remain the same
      // 验证指定的值已更新，其他值保持不变
      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.cost, 19.99);
    });

    test('should convert to and from JSON correctly (应该正确地与 JSON 进行相互转换)', () {
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

      // Verify that object created from JSON matches the original
      // 验证从 JSON 创建的对象与原始对象一致
      expect(fromJson.id, subscription.id);
      expect(fromJson.name, subscription.name);
      expect(fromJson.cost, subscription.cost);
      expect(fromJson.isFreeTrial, subscription.isFreeTrial);
    });
  });
}
