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
///   RecurringCost 和 InstallmentPlan 统一处理
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

  /// 分期中未缴的
  List<InstallmentPlan> get unpaidInstallments =>
      installmentItems.where((i) => !i.isPaidForCurrentPeriod && !i.isCompleted).toList();

  /// 分期中已缴的
  List<InstallmentPlan> get paidInstallments =>
      installmentItems.where((i) => i.isPaidForCurrentPeriod || i.isCompleted).toList();

  int get totalItemCount =>
      allRecurringItems.length + installmentItems.length;

  /// 本月应缴项数（本月到期 + 已缴，不含未来月份）
  /// 逾期项单独提示，不混入进度分数
  int get monthlyTrackableCount =>
      paidItems.length + dueThisMonth.length +
      _installmentMonthlyPaid.length + installmentDueThisMonth.length;

  /// 本月已缴项数
  int get monthlyPaidCount =>
      paidItems.length + _installmentMonthlyPaid.length;

  /// 本月已缴的分期项
  /// isPaid=true 且 nextDueDate 在下月底之前 → 说明缴的是本月或之前的账单
  List<InstallmentPlan> get installmentMonthlyPaid => _installmentMonthlyPaid;
  List<InstallmentPlan> get _installmentMonthlyPaid {
    final now = DateTime.now();
    // 下月底 = 下下月的第0天
    final cutoff = DateTime(now.year, now.month + 2, 1);
    return paidInstallments.where((i) {
      return i.nextDueDate.isBefore(cutoff);
    }).toList();
  }

  int get overdueCount =>
      unpaidItems.where((item) => item.isOverdue).length +
      unpaidInstallments.where((item) => item.isOverdue).length;

  // --- 燃烧率展示（按 DisplayCycle） ---

  double displayCost(DisplayCycle cycle) =>
      totalDailyCost * cycle.actualDays;

  double groupDisplayCost(CostCategoryGroup group, DisplayCycle cycle) =>
      (groupDailyCosts[group] ?? 0) * cycle.actualDays;

  double installmentDisplayCost(DisplayCycle cycle) =>
      installmentDaily * cycle.actualDays;

  // --- 缴费追踪：按到期时间（周期性支出） ---

  /// 本月待缴的周期性项
  List<RecurringCost> get dueThisMonth {
    final now = DateTime.now();
    return unpaidItems.where((item) {
      return item.nextDueDate.year == now.year &&
          item.nextDueDate.month == now.month;
    }).toList();
  }

  /// 已逾期的周期性项
  List<RecurringCost> get overdueItems {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return unpaidItems.where((item) {
      final due = DateTime(
          item.nextDueDate.year, item.nextDueDate.month, item.nextDueDate.day);
      return due.isBefore(today);
    }).toList();
  }

  /// 未来待缴的周期性项
  List<RecurringCost> get dueLater {
    final now = DateTime.now();
    return unpaidItems.where((item) {
      if (item.nextDueDate.year > now.year) return true;
      if (item.nextDueDate.year == now.year &&
          item.nextDueDate.month > now.month) return true;
      return false;
    }).toList();
  }

  // --- 缴费追踪：分期按到期时间 ---

  /// 本月待缴的分期项
  List<InstallmentPlan> get installmentDueThisMonth {
    final now = DateTime.now();
    return unpaidInstallments.where((item) {
      return item.nextDueDate.year == now.year &&
          item.nextDueDate.month == now.month;
    }).toList();
  }

  /// 未来待缴的分期项
  List<InstallmentPlan> get installmentDueLater {
    final now = DateTime.now();
    return unpaidInstallments.where((item) {
      if (item.nextDueDate.year > now.year) return true;
      if (item.nextDueDate.year == now.year &&
          item.nextDueDate.month > now.month) return true;
      return false;
    }).toList();
  }

  /// 已逾期的分期项
  List<InstallmentPlan> get installmentOverdueItems {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return unpaidInstallments.where((item) {
      final due = DateTime(
          item.nextDueDate.year, item.nextDueDate.month, item.nextDueDate.day);
      return due.isBefore(today);
    }).toList();
  }

  // --- 金额汇总 ---

  /// 本月待缴总额（周期性）
  double get dueThisMonthAmount =>
      dueThisMonth.fold<double>(0, (sum, item) => sum + item.paymentAmount);

  /// 逾期总额（周期性）
  double get overdueAmount =>
      overdueItems.fold<double>(0, (sum, item) => sum + item.paymentAmount);

  /// 已缴总额（周期性 + 本月相关的分期已缴）
  double get paidAmount =>
      paidItems.fold<double>(0, (sum, item) => sum + item.paymentAmount) +
      _installmentMonthlyPaid.fold<double>(0, (sum, i) => sum + i.monthlyPayment);

  /// 分期待缴总额
  double get installmentUnpaidAmount =>
      unpaidInstallments.fold<double>(0, (sum, i) => sum + i.monthlyPayment);

  /// 分期逾期总额
  double get installmentOverdueAmount =>
      installmentOverdueItems.fold<double>(0, (sum, i) => sum + i.monthlyPayment);

  /// 分期本月待缴总额
  double get installmentDueThisMonthAmount =>
      installmentDueThisMonth.fold<double>(0, (sum, i) => sum + i.monthlyPayment);

  /// 本期应缴总额（已缴 + 逾期 + 本月到期，不含未来月份）
  double get totalDueAmount =>
      paidAmount + overdueAmount + dueThisMonthAmount +
      installmentOverdueAmount + installmentDueThisMonthAmount;

  /// 缴费进度（钳制 0.0 - 1.0）
  double get paymentProgress =>
      totalDueAmount > 0 ? (paidAmount / totalDueAmount).clamp(0.0, 1.0) : 0;

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
