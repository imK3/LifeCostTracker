// sleep_cost_summary.dart
// LifeCostTracker
// 睡后成本汇总实体
// Sleep cost summary aggregate entity

import 'recurring_cost.dart';
import 'installment_plan.dart';
import 'display_cycle.dart';

/// Sleep cost summary - aggregate data for dashboard display
///
/// 睡后成本汇总
/// totalDailyCost 包含所有 active 项（不区分已付/未付）
/// 已付/未付分组仅用于 UI 展示（缴费追踪）
class SleepCostSummary {
  /// Total daily cost (ALL active items)
  /// 总日成本（所有活跃项，即燃烧率）
  final double totalDailyCost;

  /// Daily cost from fixed living expenses
  final double fixedLivingDaily;

  /// Daily cost from subscriptions
  final double subscriptionDaily;

  /// Daily cost from installment plans
  final double installmentDaily;

  // --- 缴费追踪分组（UI 展示用） ---

  /// Unpaid fixed living items (待付)
  final List<RecurringCost> unpaidFixedLivingItems;

  /// Unpaid subscription items (待付)
  final List<RecurringCost> unpaidSubscriptionItems;

  /// Paid fixed living items (本期已付)
  final List<RecurringCost> paidFixedLivingItems;

  /// Paid subscription items (本期已付)
  final List<RecurringCost> paidSubscriptionItems;

  /// Active installment plans
  final List<InstallmentPlan> installmentItems;

  // --- Computed properties ---

  /// All unpaid recurring items
  List<RecurringCost> get unpaidItems =>
      [...unpaidFixedLivingItems, ...unpaidSubscriptionItems];

  /// All paid recurring items
  List<RecurringCost> get paidItems =>
      [...paidFixedLivingItems, ...paidSubscriptionItems];

  /// All recurring items (paid + unpaid)
  List<RecurringCost> get allRecurringItems =>
      [...unpaidItems, ...paidItems];

  /// Total number of all items
  int get totalItemCount =>
      allRecurringItems.length + installmentItems.length;

  /// Number of overdue items (unpaid + past due date)
  int get overdueCount =>
      unpaidItems.where((item) => item.isOverdue).length;

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
    required this.unpaidFixedLivingItems,
    required this.unpaidSubscriptionItems,
    required this.paidFixedLivingItems,
    required this.paidSubscriptionItems,
    required this.installmentItems,
  });

  static const empty = SleepCostSummary(
    totalDailyCost: 0,
    fixedLivingDaily: 0,
    subscriptionDaily: 0,
    installmentDaily: 0,
    unpaidFixedLivingItems: [],
    unpaidSubscriptionItems: [],
    paidFixedLivingItems: [],
    paidSubscriptionItems: [],
    installmentItems: [],
  );
}
