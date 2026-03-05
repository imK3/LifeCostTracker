// calculate_wishlist_daily_savings_target_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import 'base_usecase.dart';

class DailySavingsTarget {
  final double totalCost;
  final DateTime? targetDate;
  final int daysRemaining;
  final double dailySavingsNeeded;

  DailySavingsTarget({
    required this.totalCost,
    required this.targetDate,
    required this.daysRemaining,
    required this.dailySavingsNeeded,
  });
}

class CalculateWishlistDailySavingsTargetUseCase
    implements BaseUseCase<DailySavingsTarget, WishlistItem> {
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
