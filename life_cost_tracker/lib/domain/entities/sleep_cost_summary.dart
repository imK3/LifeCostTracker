// sleep_cost_summary.dart
// LifeCostTracker
// 睡后成本汇总实体

import 'recurring_cost.dart';
import 'installment_plan.dart';
import 'display_cycle.dart';
import 'cost_category.dart';

/// Sleep cost summary - aggregate data for dashboard display
///
/// 睡后成本汇总
/// - 燃烧率：totalDailyCost，所有 active 项，用 dailyCost × actualDays 展示
/// - 缴费追踪：按到期时间分组，用实际 paymentAmount 展示
class SleepCostSummary {
  /// Total daily cost (ALL active items)
  final double totalDailyCost;

  /// Daily cost by category group
  final Map<CostCategoryGroup, double> groupDailyCosts;

  /// Installment daily cost
  final double installmentDaily;

  // --- 缴费追踪：按支付状态分组 ---

  final List<RecurringCost> unpaidItems;
  final List<RecurringCost> paidItems;
  final List<InstallmentPlan> installmentItems;

  // --- 基础聚合 ---

  List<RecurringCost> get allRecurringItems =>
      [...unpaidItems, ...paidItems];

  int get totalItemCount =>
      allRecurringItems.length + installmentItems.length;

  int get overdueCount =>
      unpaidItems.where((item) => item.isOverdue).length;

  // --- 燃烧率展示（按 DisplayCycle） ---

  double displayCost(DisplayCycle cycle) =>
      totalDailyCost * cycle.actualDays;

  double groupDisplayCost(CostCategoryGroup group, DisplayCycle cycle) =>
      (groupDailyCosts[group] ?? 0) * cycle.actualDays;

  double installmentDisplayCost(DisplayCycle cycle) =>
      installmentDaily * cycle.actualDays;

  // --- 缴费追踪：按到期时间 ---

  /// 本月待缴的项（nextDueDate 在本月内且未付）
  List<RecurringCost> get dueThisMonth {
    final now = DateTime.now();
    return unpaidItems.where((item) {
      return item.nextDueDate.year == now.year &&
          item.nextDueDate.month == now.month;
    }).toList();
  }

  /// 已逾期的项（nextDueDate 已过且未付）
  List<RecurringCost> get overdueItems {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return unpaidItems.where((item) {
      final due = DateTime(
          item.nextDueDate.year, item.nextDueDate.month, item.nextDueDate.day);
      return due.isBefore(today);
    }).toList();
  }

  /// 未来待缴的项（nextDueDate 在本月之后且未付）
  List<RecurringCost> get dueLater {
    final now = DateTime.now();
    return unpaidItems.where((item) {
      if (item.nextDueDate.year > now.year) return true;
      if (item.nextDueDate.year == now.year &&
          item.nextDueDate.month > now.month) return true;
      return false;
    }).toList();
  }

  /// 本月待缴总额（实际 paymentAmount）
  double get dueThisMonthAmount =>
      dueThisMonth.fold<double>(0, (sum, item) => sum + item.paymentAmount);

  /// 逾期总额
  double get overdueAmount =>
      overdueItems.fold<double>(0, (sum, item) => sum + item.paymentAmount);

  /// 已缴总额
  double get paidAmount =>
      paidItems.fold<double>(0, (sum, item) => sum + item.paymentAmount);

  /// 本期应缴总额（已缴 + 逾期 + 本月待缴）
  double get totalDueAmount => paidAmount + overdueAmount + dueThisMonthAmount;

  /// 缴费进度
  double get paymentProgress =>
      totalDueAmount > 0 ? paidAmount / totalDueAmount : 0;

  // --- 占比 ---

  double groupPercentage(CostCategoryGroup group) =>
      totalDailyCost > 0 ? (groupDailyCosts[group] ?? 0) / totalDailyCost : 0;

  double get installmentPercentage =>
      totalDailyCost > 0 ? installmentDaily / totalDailyCost : 0;

  /// 有数据的大类列表（按占比降序）
  List<CostCategoryGroup> get activeGroups {
    final groups = groupDailyCosts.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return groups.map((e) => e.key).toList();
  }

  const SleepCostSummary({
    required this.totalDailyCost,
    required this.groupDailyCosts,
    required this.installmentDaily,
    required this.unpaidItems,
    required this.paidItems,
    required this.installmentItems,
  });

  static const empty = SleepCostSummary(
    totalDailyCost: 0,
    groupDailyCosts: {},
    installmentDaily: 0,
    unpaidItems: [],
    paidItems: [],
    installmentItems: [],
  );
}
