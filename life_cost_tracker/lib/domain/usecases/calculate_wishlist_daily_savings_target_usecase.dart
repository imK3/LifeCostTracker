// calculate_wishlist_daily_savings_target_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'base_usecase.dart';

/// Daily savings target result
/// 每日储蓄目标结果
class DailySavingsTarget {
  /// Total cost of the item
  /// 物品总成本
  final double totalCost;

  /// Target purchase date
  /// 目标购买日期
  final DateTime? targetDate;

  /// Days remaining until the target date
  /// 距离目标日期的剩余天数
  final int daysRemaining;

  /// Daily savings needed to reach the target
  /// 达到目标所需的每日储蓄
  final double dailySavingsNeeded;

  DailySavingsTarget({
    required this.totalCost,
    required this.targetDate,
    required this.daysRemaining,
    required this.dailySavingsNeeded,
  });
}

/// Calculate wishlist daily savings target use case
/// 计算愿望清单每日储蓄目标用例
class CalculateWishlistDailySavingsTargetUseCase
    implements BaseUseCase<DailySavingsTarget, WishlistItem> {
      
  /// Execute the use case to calculate the daily savings target
  /// 执行用例以计算每日储蓄目标
  @override
  Future<DailySavingsTarget> call(WishlistItem item) async {
    final now = DateTime.now();
    DateTime? targetDate = item.targetDate;
    int daysRemaining = 0;
    double dailySavingsNeeded = 0;

    if (targetDate != null && targetDate.isAfter(now)) {
      daysRemaining = targetDate.difference(now).inDays;
      if (daysRemaining > 0) {
        dailySavingsNeeded = item.totalCost / daysRemaining;
      } else {
        daysRemaining = 1;
        dailySavingsNeeded = item.totalCost;
      }
    } else {
      // If no target date, default to 30 days
      // 如果没有目标日期，默认 30 天
      daysRemaining = 30;
      dailySavingsNeeded = item.totalCost / 30;
      targetDate = now.add(const Duration(days: 30));
    }

    return DailySavingsTarget(
      totalCost: item.totalCost,
      targetDate: targetDate,
      daysRemaining: daysRemaining,
      dailySavingsNeeded: dailySavingsNeeded,
    );
  }
}
