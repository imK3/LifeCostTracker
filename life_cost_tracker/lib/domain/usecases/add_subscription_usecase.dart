// add_subscription_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';
import 'base_usecase.dart';

class AddSubscriptionUseCase implements BaseUseCase<void, Subscription> {
  final SubscriptionRepository repository;

  AddSubscriptionUseCase(this.repository);

  @override
  Future<void> call(Subscription subscription) async {
    await repository.addSubscription(subscription);
  }
}
