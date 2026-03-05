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

class CalculateAverageDailyCostUseCase implements BaseUseCase<double?, NoParams> {
  final ExpenseRepository expenseRepository;
  final SubscriptionRepository subscriptionRepository;
  final WishlistItemRepository wishlistItemRepository;

  CalculateAverageDailyCostUseCase({
    required this.expenseRepository,
    required this.subscriptionRepository,
    required this.wishlistItemRepository,
  });

  @override
  Future<double?> call(NoParams params) async {
    double totalDailyCost = 0.0;
    int itemCount = 0;

    // Add subscriptions (recurring daily costs)
    final subscriptions = await subscriptionRepository.getSubscriptions();
    for (final sub in subscriptions) {
      totalDailyCost += sub.dailyCost;
      itemCount++;
    }

    // Add owned wishlist items (daily ownership costs)
    final wishlistItems = await wishlistItemRepository.getWishlistItems();
    for (final item in wishlistItems) {
      if (item.isOwned && item.dailyCost != null) {
        totalDailyCost += item.dailyCost!;
        itemCount++;
      }
    }

    // Add recent one-time expenses (amortized over 30 days)
    final expenses = await expenseRepository.getExpenses();
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentExpenses = expenses.where((e) => e.date.isAfter(thirtyDaysAgo));

    for (final expense in recentExpenses) {
      if (expense.estimatedUsageDays != null &&
          expense.estimatedUsageDays! > 0) {
        totalDailyCost += expense.dailyCost!;
      } else {
        // Amortize over 30 days if no usage days specified
        totalDailyCost += expense.amount / 30;
      }
      itemCount++;
    }

    if (itemCount == 0) return null;
    return totalDailyCost;
  }
}
