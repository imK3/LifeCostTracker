// check_wishlist_daily_cost_impact_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'calculate_average_daily_cost_usecase.dart';
import 'base_usecase.dart';

class DailyCostImpact {
  final double currentDailyCost;
  final double itemDailyCost;
  final double newDailyCost;
  final double absoluteIncrease;
  final double percentageIncrease;

  DailyCostImpact({
    required this.currentDailyCost,
    required this.itemDailyCost,
    required this.newDailyCost,
    required this.absoluteIncrease,
    required this.percentageIncrease,
  });
}

class CheckWishlistDailyCostImpactUseCase
    implements BaseUseCase<DailyCostImpact, WishlistItem> {
  final CalculateAverageDailyCostUseCase calculateAverageDailyCostUseCase;

  CheckWishlistDailyCostImpactUseCase(this.calculateAverageDailyCostUseCase);

  @override
  Future<DailyCostImpact> call(WishlistItem item) async {
    final currentDailyCost =
        await calculateAverageDailyCostUseCase(const NoParams());

    final current = currentDailyCost ?? 0;
    final itemCost = item.dailyCost ?? 0;
    final newCost = current + itemCost;
    final absoluteIncrease = itemCost;
    final percentageIncrease = current > 0 ? itemCost / current : 0;

    return DailyCostImpact(
      currentDailyCost: current,
      itemDailyCost: itemCost,
      newDailyCost: newCost,
      absoluteIncrease: absoluteIncrease,
      percentageIncrease: percentageIncrease,
    );
  }
}
