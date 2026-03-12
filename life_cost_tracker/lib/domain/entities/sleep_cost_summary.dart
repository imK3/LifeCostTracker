// sleep_cost_summary.dart
// LifeCostTracker
// 睡后成本汇总实体
// Sleep cost summary aggregate entity

import 'recurring_cost.dart';
import 'installment_plan.dart';
import 'display_cycle.dart';

/// Sleep cost summary - aggregate data for dashboard display
/// 睡后成本汇总 - Dashboard 展示用的聚合数据
class SleepCostSummary {
  /// Total daily cost (only unpaid items)
  /// 总日成本（仅未支付项）
  final double totalDailyCost;

  /// Daily cost from unpaid fixed living expenses
  final double fixedLivingDaily;

  /// Daily cost from unpaid subscriptions
  final double subscriptionDaily;

  /// Daily cost from installment plans
  final double installmentDaily;

  /// Unpaid fixed living items (计入睡后成本)
  final List<RecurringCost> fixedLivingItems;

  /// Unpaid subscription items (计入睡后成本)
  final List<RecurringCost> subscriptionItems;

  /// Active installment plans
  final List<InstallmentPlan> installmentItems;

  /// Already paid fixed living items (本期已付，不计入睡后成本)
  final List<RecurringCost> paidFixedLivingItems;

  /// Already paid subscription items (本期已付，不计入睡后成本)
  final List<RecurringCost> paidSubscriptionItems;

  /// Total number of unpaid cost items
  int get unpaidItemCount =>
      fixedLivingItems.length +
      subscriptionItems.length +
      installmentItems.length;

  /// Total number of all items (paid + unpaid)
  int get totalItemCount =>
      unpaidItemCount +
      paidFixedLivingItems.length +
      paidSubscriptionItems.length;

  /// Number of overdue items
  int get overdueCount {
    int count = 0;
    for (final item in fixedLivingItems) {
      if (item.isOverdue) count++;
    }
    for (final item in subscriptionItems) {
      if (item.isOverdue) count++;
    }
    return count;
  }

  /// Get display cost for a given cycle
  double displayCost(DisplayCycle cycle) =>
      totalDailyCost * cycle.daysMultiplier;

  double fixedLivingDisplayCost(DisplayCycle cycle) =>
      fixedLivingDaily * cycle.daysMultiplier;

  double subscriptionDisplayCost(DisplayCycle cycle) =>
      subscriptionDaily * cycle.daysMultiplier;

  double installmentDisplayCost(DisplayCycle cycle) =>
      installmentDaily * cycle.daysMultiplier;

  /// Percentage of total from fixed living costs
  double get fixedLivingPercentage =>
      totalDailyCost > 0 ? fixedLivingDaily / totalDailyCost : 0;

  /// Percentage of total from subscriptions
  double get subscriptionPercentage =>
      totalDailyCost > 0 ? subscriptionDaily / totalDailyCost : 0;

  /// Percentage of total from installments
  double get installmentPercentage =>
      totalDailyCost > 0 ? installmentDaily / totalDailyCost : 0;

  const SleepCostSummary({
    required this.totalDailyCost,
    required this.fixedLivingDaily,
    required this.subscriptionDaily,
    required this.installmentDaily,
    required this.fixedLivingItems,
    required this.subscriptionItems,
    required this.installmentItems,
    this.paidFixedLivingItems = const [],
    this.paidSubscriptionItems = const [],
  });

  static const empty = SleepCostSummary(
    totalDailyCost: 0,
    fixedLivingDaily: 0,
    subscriptionDaily: 0,
    installmentDaily: 0,
    fixedLivingItems: [],
    subscriptionItems: [],
    installmentItems: [],
  );
}
