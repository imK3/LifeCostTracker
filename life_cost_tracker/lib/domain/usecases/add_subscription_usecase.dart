// add_subscription_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';
import 'base_usecase.dart';

/// Add subscription use case
/// 添加订阅用例
class AddSubscriptionUseCase implements BaseUseCase<void, Subscription> {
  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Constructor
  /// 构造函数
  AddSubscriptionUseCase({required this.subscriptionRepository});

  /// Execute the use case
  /// 执行用例
  @override
  Future<void> call(Subscription subscription) async {
    await subscriptionRepository.addSubscription(subscription);
  }
}
