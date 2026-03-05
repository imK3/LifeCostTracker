// subscription_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getSubscriptions();
  Future<void> addSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> deleteSubscription(String id);
}
