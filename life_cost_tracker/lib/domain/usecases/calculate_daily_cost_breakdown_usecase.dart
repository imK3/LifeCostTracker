// calculate_daily_cost_breakdown_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/subscription.dart';
import '../entities/wishlist_item.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

class DailyCostBreakdown {
  final double subscriptionDailyCost;
  final double ownedItemDailyCost;
  final double oneTimeExpenseDailyCost;

  double get totalDailyCost =>
      subscriptionDailyCost + ownedItemDailyCost + oneTimeExpenseDailyCost;

  DailyCostBreakdown({
    required this.subscriptionDailyCost,
    required this.ownedItemDailyCost,
    required this.oneTimeExpenseDailyCost,
  });
}

class CalculateDailyCostBreakdownUseCase
    implements BaseUseCase<DailyCostBreakdown, NoParams> {
  final SubscriptionRepository subscriptionRepository;
  final WishlistItemRepository wishlistItemRepository;

  CalculateDailyCostBreakdownUseCase({
    required this.subscriptionRepository,
    required this.wishlistItemRepository,
  });

  @override
  Future<DailyCostBreakdown> call(NoParams params) async {
    double subscriptionCost = 0.0;
    double ownedItemCost = 0.0;

    // Calculate subscription daily cost
    final subscriptions = await subscriptionRepository.getSubscriptions();
    for (final sub in subscriptions) {
      subscriptionCost += sub.dailyCost;
    }

    // Calculate owned items daily cost
    final wishlistItems = await wishlistItemRepository.getWishlistItems();
    for (final item in wishlistItems) {
      if (item.isOwned && item.dailyCost != null) {
        ownedItemCost += item.dailyCost!;
      }
    }

    return DailyCostBreakdown(
      subscriptionDailyCost: subscriptionCost,
      ownedItemDailyCost: ownedItemCost,
      oneTimeExpenseDailyCost: 0.0, // Would need expense repository
    );
  }
}
