// check_wishlist_daily_cost_impact_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'calculate_average_daily_cost_usecase.dart';
import 'base_usecase.dart';

/// Daily cost impact result
/// 每日成本影响结果
class DailyCostImpact {
  /// Current average daily cost
  /// 当前平均每日成本
  final double currentDailyCost;

  /// Daily cost of the new item
  /// 新物品的每日成本
  final double itemDailyCost;

  /// New average daily cost after adding the item
  /// 添加物品后的新平均每日成本
  final double newDailyCost;

  /// Absolute increase in daily cost
  /// 每日成本的绝对增加量
  final double absoluteIncrease;

  /// Percentage increase in daily cost
  /// 每日成本的增加百分比
  final double percentageIncrease;

  DailyCostImpact({
    required this.currentDailyCost,
    required this.itemDailyCost,
    required this.newDailyCost,
    required this.absoluteIncrease,
    required this.percentageIncrease,
  });
}

/// Check wishlist daily cost impact use case
/// 检查愿望清单每日成本影响用例
class CheckWishlistDailyCostImpactUseCase
    implements BaseUseCase<DailyCostImpact, WishlistItem> {
  /// Calculate average daily cost use case
  /// 计算平均每日成本用例
  final CalculateAverageDailyCostUseCase calculateAverageDailyCostUseCase;

  /// Constructor
  /// 构造函数
  CheckWishlistDailyCostImpactUseCase(this.calculateAverageDailyCostUseCase);

  /// Execute the use case to check the impact of a wishlist item on daily cost
  /// 执行用例以检查愿望清单项对每日成本的影响
  @override
  Future<DailyCostImpact> call(WishlistItem item) async {
    final currentDailyCost =
        await calculateAverageDailyCostUseCase(NoParams());

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
