// calculate_average_daily_cost_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/expense.dart';
import '../entities/subscription.dart';
import '../entities/wishlist_item.dart';
import '../repositories/expense_repository.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

/// Calculate average daily cost use case
/// 计算平均每日成本用例
class CalculateAverageDailyCostUseCase implements BaseUseCase<double?, NoParams> {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository wishlistItemRepository;

  /// Constructor
  /// 构造函数
  CalculateAverageDailyCostUseCase({
    required this.expenseRepository,
    required this.subscriptionRepository,
    required this.wishlistItemRepository,
  });

  /// Execute the use case to calculate the overall average daily cost
  /// 执行用例以计算整体平均每日成本
  @override
  Future<double?> call(NoParams params) async {
    double totalDailyCost = 0.0;
    int itemCount = 0;

    // Add subscriptions (recurring daily costs)
    // 添加订阅（持续的每日成本）
    final subscriptions = await subscriptionRepository.getSubscriptions();
    for (final sub in subscriptions) {
      totalDailyCost += sub.dailyCost;
      itemCount++;
    }

    // Add owned wishlist items (daily ownership costs)
    // 添加已拥有的愿望清单项（每日拥有成本）
    final wishlistItems = await wishlistItemRepository.getWishlistItems();
    for (final item in wishlistItems) {
      if (item.isOwned && item.dailyCost != null) {
        totalDailyCost += item.dailyCost!;
        itemCount++;
      }
    }

    // Add recent one-time expenses (amortized over 30 days)
    // 添加最近的一次性支出（按 30 天摊销）
    final expenses = await expenseRepository.getExpenses();
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentExpenses = expenses.where((e) => e.date.isAfter(thirtyDaysAgo));

    for (final expense in recentExpenses) {
      if (expense.estimatedUsageDays != null &&
          expense.estimatedUsageDays! > 0) {
        totalDailyCost += expense.dailyCost!;
      } else {
        // Amortize over 30 days if no usage days specified
        // 如果未指定使用天数，则按 30 天摊销
        totalDailyCost += expense.amount / 30;
      }
      itemCount++;
    }

    if (itemCount == 0) return null;
    return totalDailyCost;
  }
}
