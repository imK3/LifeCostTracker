// calculate_sleep_cost_usecase.dart
// LifeCostTracker
// 核心用例：计算睡后成本

import 'base_usecase.dart';
import '../entities/sleep_cost_summary.dart';
import '../entities/cost_category.dart';
import '../repositories/recurring_cost_repository.dart';
import '../repositories/installment_plan_repository.dart';

/// Calculate the total "sleep cost" — your daily burn rate
///
/// 睡后成本 = 你的生活燃烧率
/// 所有 active 的周期性成本都计入，不管本期是否已支付。
/// 只有 isActive=false（退租、取消订阅）才不算。
///
/// 已付/未付状态仅用于 UI 展示（缴费追踪、到期提醒）。
class CalculateSleepCostUseCase
    implements BaseUseCase<SleepCostSummary, NoParams> {
  final RecurringCostRepository recurringCostRepository;
  final InstallmentPlanRepository installmentPlanRepository;

  CalculateSleepCostUseCase({
    required this.recurringCostRepository,
    required this.installmentPlanRepository,
  });

  @override
  Future<SleepCostSummary> call(NoParams params) async {
    final recurringCosts = await recurringCostRepository.getRecurringCosts();
    final installments =
        await installmentPlanRepository.getInstallmentPlans();

    // Only active items count
    final activeRecurring =
        recurringCosts.where((c) => c.isActive).toList();
    final activeInstallments =
        installments.where((i) => !i.isCompleted).toList();

    // Split by payment status
    final unpaidItems =
        activeRecurring.where((c) => !c.isPaidForCurrentPeriod).toList();
    final paidItems =
        activeRecurring.where((c) => c.isPaidForCurrentPeriod).toList();

    // Aggregate daily cost by category group
    final groupDailyCosts = <CostCategoryGroup, double>{};
    for (final item in activeRecurring) {
      final group = item.group;
      groupDailyCosts[group] = (groupDailyCosts[group] ?? 0) + item.dailyCost;
    }

    final recurringDaily =
        activeRecurring.fold<double>(0, (sum, c) => sum + c.dailyCost);
    final installmentDaily =
        activeInstallments.fold<double>(0, (sum, i) => sum + i.dailyCost);

    return SleepCostSummary(
      totalDailyCost: recurringDaily + installmentDaily,
      groupDailyCosts: groupDailyCosts,
      installmentDaily: installmentDaily,
      unpaidItems: unpaidItems,
      paidItems: paidItems,
      installmentItems: activeInstallments,
    );
  }
}
