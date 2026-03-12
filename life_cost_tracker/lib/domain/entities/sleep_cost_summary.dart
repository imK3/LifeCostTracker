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
  /// Total daily cost (all categories combined)
  /// 总日成本（所有分类合计）
  final double totalDailyCost;

  /// Daily cost from fixed living expenses
  /// 固定生活成本折日
  final double fixedLivingDaily;

  /// Daily cost from subscriptions
  /// 订阅费用折日
  final double subscriptionDaily;

  /// Daily cost from installment plans
  /// 分期承诺折日
  final double installmentDaily;

  /// List of active recurring costs (fixed living)
  /// 活跃的固定生活成本列表
  final List<RecurringCost> fixedLivingItems;

  /// List of active recurring costs (subscriptions)
  /// 活跃的订阅费用列表
  final List<RecurringCost> subscriptionItems;

  /// List of active installment plans
  /// 活跃的分期承诺列表
  final List<InstallmentPlan> installmentItems;

  /// Total number of active cost items
  /// 活跃成本项总数
  int get totalItemCount =>
      fixedLivingItems.length +
      subscriptionItems.length +
      installmentItems.length;

  /// Get display cost for a given cycle
  /// 获取指定周期的展示成本
  double displayCost(DisplayCycle cycle) =>
      totalDailyCost * cycle.daysMultiplier;

  /// Get fixed living display cost for a given cycle
  double fixedLivingDisplayCost(DisplayCycle cycle) =>
      fixedLivingDaily * cycle.daysMultiplier;

  /// Get subscription display cost for a given cycle
  double subscriptionDisplayCost(DisplayCycle cycle) =>
      subscriptionDaily * cycle.daysMultiplier;

  /// Get installment display cost for a given cycle
  double installmentDisplayCost(DisplayCycle cycle) =>
      installmentDaily * cycle.daysMultiplier;

  /// Percentage of total from fixed living costs
  /// 固定生活成本占比
  double get fixedLivingPercentage =>
      totalDailyCost > 0 ? fixedLivingDaily / totalDailyCost : 0;

  /// Percentage of total from subscriptions
  /// 订阅费用占比
  double get subscriptionPercentage =>
      totalDailyCost > 0 ? subscriptionDaily / totalDailyCost : 0;

  /// Percentage of total from installments
  /// 分期承诺占比
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
  });

  /// Empty summary with zero costs
  /// 空汇总
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
