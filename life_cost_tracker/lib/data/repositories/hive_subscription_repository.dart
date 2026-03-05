// hive_subscription_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// Hive 订阅仓库实现
// Hive Subscription Repository Implementation

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

/// Hive implementation of SubscriptionRepository
/// 订阅仓库的 Hive 实现
class HiveSubscriptionRepository implements SubscriptionRepository {
  /// Hive box for subscriptions
  /// 订阅的 Hive 盒子
  final Box<Subscription> _subscriptionBox;

  /// Constructor
  /// 构造函数
  HiveSubscriptionRepository(this._subscriptionBox);

  /// Get all subscriptions
  /// 获取所有订阅
  @override
  Future<List<Subscription>> getSubscriptions() async {
    return _subscriptionBox.values.toList();
  }

  /// Add a new subscription
  /// 添加新订阅
  @override
  Future<void> addSubscription(Subscription subscription) async {
    await _subscriptionBox.put(subscription.id, subscription);
  }

  /// Update an existing subscription
  /// 更新现有订阅
  @override
  Future<void> updateSubscription(Subscription subscription) async {
    await _subscriptionBox.put(subscription.id, subscription);
  }

  /// Delete a subscription by id
  /// 根据 ID 删除订阅
  @override
  Future<void> deleteSubscription(String id) async {
    await _subscriptionBox.delete(id);
  }
}
