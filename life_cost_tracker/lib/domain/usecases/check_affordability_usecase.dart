// check_affordability_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'calculate_average_daily_cost_usecase.dart';
import 'base_usecase.dart';

/// Affordability check result
/// 可负担性检查结果
class AffordabilityResult {
  /// Whether the item is considered affordable
  /// 是否被认为是可负担的
  final bool isAffordable;

  /// Current average daily cost
  /// 当前平均每日成本
  final double currentDailyCost;

  /// New average daily cost if item is purchased
  /// 购买该物品后的新平均每日成本
  final double newDailyCost;

  /// Impact percentage on the daily cost
  /// 对每日成本的影响百分比
  final double impactPercentage;

  /// Recommendation or warning message
  /// 建议或警告信息
  final String? recommendation;

  AffordabilityResult({
    required this.isAffordable,
    required this.currentDailyCost,
    required this.newDailyCost,
    required this.impactPercentage,
    this.recommendation,
  });
}

/// Check affordability use case
/// 检查可负担性用例
class CheckAffordabilityUseCase
    implements BaseUseCase<AffordabilityResult, WishlistItem> {
  /// Calculate average daily cost use case
  /// 计算平均每日成本用例
  final CalculateAverageDailyCostUseCase calculateAverageDailyCostUseCase;

  /// Constructor
  /// 构造函数
  CheckAffordabilityUseCase(this.calculateAverageDailyCostUseCase);

  /// Execute the use case to check if a wishlist item is affordable
  /// 执行用例以检查愿望清单项是否可负担
  @override
  Future<AffordabilityResult> call(WishlistItem item) async {
    final currentDailyCost =
        await calculateAverageDailyCostUseCase(NoParams());

    if (currentDailyCost == null) {
      return AffordabilityResult(
        isAffordable: true,
        currentDailyCost: 0,
        newDailyCost: item.dailyCost ?? 0,
        impactPercentage: 0,
        recommendation: '添加你的第一个物品！', // Add your first item!
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
      // This item will increase your daily cost by over 30%, consider carefully.
    } else if (impactPercentage > 0.1) {
      recommendation = '这个物品会增加你 10-30% 的每日成本，确保你真的需要它。';
      // This item will increase your daily cost by 10-30%, make sure you really need it.
    } else {
      recommendation = '这个物品对你的每日成本影响不大，可以考虑购买。';
      // This item has little impact on your daily cost, consider buying it.
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
