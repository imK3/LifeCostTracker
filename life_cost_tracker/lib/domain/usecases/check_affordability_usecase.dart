// check_affordability_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'calculate_average_daily_cost_usecase.dart';
import 'base_usecase.dart';

class AffordabilityResult {
  final bool isAffordable;
  final double currentDailyCost;
  final double newDailyCost;
  final double impactPercentage;
  final String? recommendation;

  AffordabilityResult({
    required this.isAffordable,
    required this.currentDailyCost,
    required this.newDailyCost,
    required this.impactPercentage,
    this.recommendation,
  });
}

class CheckAffordabilityUseCase
    implements BaseUseCase<AffordabilityResult, WishlistItem> {
  final CalculateAverageDailyCostUseCase calculateAverageDailyCostUseCase;

  CheckAffordabilityUseCase(this.calculateAverageDailyCostUseCase);

  @override
  Future<AffordabilityResult> call(WishlistItem item) async {
    final currentDailyCost =
        await calculateAverageDailyCostUseCase(const NoParams());

    if (currentDailyCost == null) {
      return AffordabilityResult(
        isAffordable: true,
        currentDailyCost: 0,
        newDailyCost: item.dailyCost ?? 0,
        impactPercentage: 0,
        recommendation: '添加你的第一个物品！',
      );
    }

    final itemDailyCost = item.dailyCost ?? 0;
    final newDailyCost = currentDailyCost + itemDailyCost;
    final impactPercentage = itemDailyCost / currentDailyCost;

    String? recommendation;
    bool isAffordable = true;

    if (impactPercentage > 0.3) {
      isAffordable = false;
      recommendation = '这个物品会增加你 30% 以上的每日成本，建议再考虑一下。';
    } else if (impactPercentage > 0.1) {
      recommendation = '这个物品会增加你 10-30% 的每日成本，确保你真的需要它。';
    } else {
      recommendation = '这个物品对你的每日成本影响不大，可以考虑购买。';
    }

    return AffordabilityResult(
      isAffordable: isAffordable,
      currentDailyCost: currentDailyCost,
      newDailyCost: newDailyCost,
      impactPercentage: impactPercentage,
      recommendation: recommendation,
    );
  }
}
