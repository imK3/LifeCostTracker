// calculate_daily_cost_breakdown_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';
import '../entities/wishlist_item.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

/// Daily cost breakdown result
/// 每日成本明细结果
class DailyCostBreakdown {
  /// Daily cost of subscriptions
  /// 订阅的每日成本
  final double subscriptionDailyCost;

  /// Daily cost of owned items
  /// 已拥有物品的每日成本
  final double ownedItemDailyCost;

  /// Daily cost of one-time expenses
  /// 一次性支出的每日成本
  final double oneTimeExpenseDailyCost;

  /// Total daily cost
  /// 总每日成本
  double get totalDailyCost =>
      subscriptionDailyCost + ownedItemDailyCost + oneTimeExpenseDailyCost;

  DailyCostBreakdown({
    required this.subscriptionDailyCost,
    required this.ownedItemDailyCost,
    required this.oneTimeExpenseDailyCost,
  });
}

/// Calculate daily cost breakdown use case
/// 计算每日成本明细用例
class CalculateDailyCostBreakdownUseCase
    implements BaseUseCase<DailyCostBreakdown, NoParams> {
  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository wishlistItemRepository;

  /// Constructor
  /// 构造函数
  CalculateDailyCostBreakdownUseCase({
    required this.subscriptionRepository,
    required this.wishlistItemRepository,
  });

  /// Execute the use case to calculate the breakdown of daily costs
  /// 执行用例以计算每日成本的明细
  @override
  Future<DailyCostBreakdown> call(NoParams params) async {
    double subscriptionCost = 0.0;
    double ownedItemCost = 0.0;

    // Calculate subscription daily cost
    // 计算订阅每日成本
    final subscriptions = await subscriptionRepository.getSubscriptions();
    for (final sub in subscriptions) {
      subscriptionCost += sub.dailyCost;
    }

    // Calculate owned items daily cost
    // 计算已拥有物品的每日成本
    final wishlistItems = await wishlistItemRepository.getWishlistItems();
    for (final item in wishlistItems) {
      if (item.isOwned && item.dailyCost != null) {
        ownedItemCost += item.dailyCost!;
      }
    }

    return DailyCostBreakdown(
      subscriptionDailyCost: subscriptionCost,
      ownedItemDailyCost: ownedItemCost,
      oneTimeExpenseDailyCost: 0.0, // Would need expense repository // 需要支出仓库来实现
    );
  }
}
