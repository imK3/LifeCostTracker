// generate_daily_cost_trend_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 生成每日成本趋势用例
// Generate daily cost trend use case

import '../entities/expense.dart';
import '../entities/subscription.dart';
import '../entities/wishlist_item.dart';
import '../repositories/expense_repository.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

/// Daily cost data point
/// 每日成本数据点
class DailyCostDataPoint {
  /// Date
  /// 日期
  final DateTime date;

  /// Daily cost
  /// 每日成本
  final double dailyCost;

  /// Breakdown by category
  /// 按分类的明细
  final Map<String, double> breakdown;

  DailyCostDataPoint({
    required this.date,
    required this.dailyCost,
    required this.breakdown,
  });
}

/// Generate daily cost trend use case
/// 生成每日成本趋势用例
class GenerateDailyCostTrendUseCase
    implements BaseUseCase<List<DailyCostDataPoint>, DateTime> {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Wishlist item repository
  ///愿望清单仓库
  final WishlistItemRepository wishlistItemRepository;

  /// Constructor
  /// 构造函数
  GenerateDailyCostTrendUseCase({
    required this.expenseRepository,
    required this.subscriptionRepository,
    required this.wishlistItemRepository,
  });

  /// Execute use case to generate daily cost trend
  /// 执行用例以生成每日成本趋势
  @override
  Future<List<DailyCostDataPoint>> call(DateTime endDate) async {
    final startDate = endDate.subtract(const Duration(days: 30));
    final dailyCostTrend = <DailyCostDataPoint>[];

    // Get subscriptions (ongoing daily costs)
    // 获取订阅（持续的每日成本）
    final subscriptions = await subscriptionRepository.getSubscriptions();
    double subscriptionDailyCost = 0;
    for (final sub in subscriptions) {
      subscriptionDailyCost += sub.dailyCost;
    }

    // Get owned wishlist items (ongoing daily costs)
    // 获取已拥有的愿望清单项（持续的每日成本）
    final wishlistItems = await wishlistItemRepository.getWishlistItems();
    double ownedItemDailyCost = 0;
    for (final item in wishlistItems) {
      if (item.isOwned && item.dailyCost != null) {
        ownedItemDailyCost += item.dailyCost!;
      }
    }

    // Generate daily data points
    // 生成每日数据点
    for (int i = 0; i <= 30; i++) {
      final date = startDate.add(Duration(days: i));
      final breakdown = <String, double>{
        'Subscriptions': subscriptionDailyCost,
        'Owned Items': ownedItemDailyCost,
        'One-time Expenses': 0,
      };

      dailyCostTrend.add(
        DailyCostDataPoint(
          date: date,
          dailyCost: subscriptionDailyCost + ownedItemDailyCost,
          breakdown: breakdown,
        ),
      );
    }

    return dailyCostTrend;
  }
}
