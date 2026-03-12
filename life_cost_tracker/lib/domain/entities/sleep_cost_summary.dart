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

  // --- 本月收支追踪 ---

  /// 本月已支付总额（周期性 + 分期）
  /// 只统计本月到期且已付的周期性项，以及分期的月供
  double get monthlyPaidAmount {
    return paidItems.fold<double>(0, (sum, item) => sum + item.amount);
  }

  /// 本月剩余未支付总额
  /// 统计本月内到期但未付的周期性项
  double get monthlyUnpaidAmount {
    return unpaidItems.fold<double>(0, (sum, item) {
      return sum + item.amount;
    });
  }

  /// 本月应付总额（已付 + 未付）
  double get monthlyTotalDue => monthlyPaidAmount + monthlyUnpaidAmount;

  /// 本月支付进度 (0.0 ~ 1.0)
  double get monthlyPaymentProgress =>
      monthlyTotalDue > 0 ? monthlyPaidAmount / monthlyTotalDue : 0;

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
