// sleep_cost_summary.dart
// LifeCostTracker
// 睡后成本汇总实体

import 'dart:math' as math;
import 'recurring_cost.dart';
import 'installment_plan.dart';
import 'display_cycle.dart';

/// Sleep cost summary - aggregate data for dashboard display
///
/// 睡后成本汇总
/// totalDailyCost 包含所有 active 项（不区分已付/未付），即燃烧率
/// 已付/未付分组用于缴费追踪
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

  // --- 缴费追踪分组 ---

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

  // --- 基础聚合 ---

  List<RecurringCost> get unpaidItems =>
      [...unpaidFixedLivingItems, ...unpaidSubscriptionItems];

  List<RecurringCost> get paidItems =>
      [...paidFixedLivingItems, ...paidSubscriptionItems];

  List<RecurringCost> get allRecurringItems =>
      [...unpaidItems, ...paidItems];

  int get totalItemCount =>
      allRecurringItems.length + installmentItems.length;

  int get overdueCount =>
      unpaidItems.where((item) => item.isOverdue).length;

  // --- 燃烧率展示（按 DisplayCycle） ---

  /// 燃烧率 = dailyCost × 实际天数
  double displayCost(DisplayCycle cycle) =>
      totalDailyCost * cycle.actualDays;

  double fixedLivingDisplayCost(DisplayCycle cycle) =>
      fixedLivingDaily * cycle.actualDays;

  double subscriptionDisplayCost(DisplayCycle cycle) =>
      subscriptionDaily * cycle.actualDays;

  double installmentDisplayCost(DisplayCycle cycle) =>
      installmentDaily * cycle.actualDays;

  // --- 缴费追踪（按 DisplayCycle） ---

  /// 已缴金额
  /// 已付项：dailyCost × min(账单覆盖天数, 显示周期天数)
  /// 公式：一笔已付款覆盖了它的 billingCycle 天数，
  ///       但在显示周期内最多只能算显示周期的天数
  double paidAmountFor(DisplayCycle cycle) {
    final displayDays = cycle.actualDays;
    return paidItems.fold<double>(0, (sum, item) {
      final coveredDays = item.billingCycle.daysInCycle;
      return sum + item.dailyCost * math.min(coveredDays, displayDays);
    });
  }

  /// 待缴金额
  /// 未付项：dailyCost × 显示周期天数
  /// 已付项剩余部分：dailyCost × max(0, 显示周期天数 - 账单覆盖天数)
  double unpaidAmountFor(DisplayCycle cycle) {
    final displayDays = cycle.actualDays;
    // Unpaid items: full display period
    final unpaidTotal = unpaidItems.fold<double>(
        0, (sum, item) => sum + item.dailyCost * displayDays);
    // Paid items: remaining uncovered portion
    final paidRemaining = paidItems.fold<double>(0, (sum, item) {
      final coveredDays = item.billingCycle.daysInCycle;
      final remaining = math.max(0, displayDays - coveredDays);
      return sum + item.dailyCost * remaining;
    });
    return unpaidTotal + paidRemaining;
  }

  /// 应付总额 = 所有 active 项 × 显示周期天数
  double totalDueFor(DisplayCycle cycle) =>
      totalDailyCost * cycle.actualDays;

  /// 支付进度 (0.0 ~ 1.0)
  double paymentProgressFor(DisplayCycle cycle) {
    final total = totalDueFor(cycle);
    return total > 0 ? paidAmountFor(cycle) / total : 0;
  }

  // --- 占比 ---

  double get fixedLivingPercentage =>
      totalDailyCost > 0 ? fixedLivingDaily / totalDailyCost : 0;

  double get subscriptionPercentage =>
      totalDailyCost > 0 ? subscriptionDaily / totalDailyCost : 0;

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
