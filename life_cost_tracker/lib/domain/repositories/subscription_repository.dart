// subscription_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';

/// Subscription repository interface
/// 订阅仓库接口
abstract class SubscriptionRepository {
  /// Get all subscriptions
  /// 获取所有订阅
  Future<List<Subscription>> getSubscriptions();

  /// Add a new subscription
  /// 添加新订阅
  Future<void> addSubscription(Subscription subscription);

  /// Update an existing subscription
  /// 更新现有订阅
  Future<void> updateSubscription(Subscription subscription);

  /// Delete a subscription by id
  /// 根据 ID 删除订阅
  Future<void> deleteSubscription(String id);
}
