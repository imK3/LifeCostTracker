// calculate_sleep_cost_usecase.dart
// LifeCostTracker
// 核心用例：计算睡后成本

import 'base_usecase.dart';
import '../entities/sleep_cost_summary.dart';
import '../entities/cost_category.dart';
import '../entities/recurring_cost.dart';
import '../entities/installment_plan.dart';
import '../repositories/recurring_cost_repository.dart';
import '../repositories/installment_plan_repository.dart';

/// Calculate the total "sleep cost" — your daily burn rate
///
/// 睡后成本 = 你的生活燃烧率
/// 所有 active 的周期性成本都计入，不管本期是否已支付。
/// 只有 isActive=false（退租、取消订阅）才不算。
///
/// **自动推进规则**：
/// - 到期日已过 → 自动视为已缴，nextDueDate 推进到下一期
/// - 提前手动标记已缴 → isPaidForCurrentPeriod=true，到期日不变
/// - 到期日过后，即使是提前缴的，也正常推进到下一期
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 自动推进过期的周期性项
    final processedRecurring = <RecurringCost>[];
    for (final item in recurringCosts) {
      if (!item.isActive) {
        processedRecurring.add(item);
        continue;
      }
      var current = item;
      bool advanced = false;
      // 到期日严格在今天之前（不含当天） → 自动推进
      while (DateTime(current.nextDueDate.year, current.nextDueDate.month,
              current.nextDueDate.day)
          .isBefore(today)) {
        current = current.copyWith(
          nextDueDate: current.nextPeriodDueDate,
          isPaidForCurrentPeriod: false,
        );
        advanced = true;
      }
      if (advanced) {
        await recurringCostRepository.updateRecurringCost(current);
      }
      processedRecurring.add(current);
    }

    // 自动推进过期的分期项
    final processedInstallments = <InstallmentPlan>[];
    for (final item in installments) {
      if (item.isCompleted) {
        processedInstallments.add(item);
        continue;
      }
      var current = item;
      bool advanced = false;
      while (DateTime(current.nextDueDate.year, current.nextDueDate.month,
                  current.nextDueDate.day)
              .isBefore(today) &&
          !current.isCompleted) {
        current = current.copyWith(
          paidPeriods: current.paidPeriods + 1,
          nextDueDate: current.nextPeriodDueDate,
          isPaidForCurrentPeriod: false,
        );
        advanced = true;
      }
      if (advanced) {
        await installmentPlanRepository.updateInstallmentPlan(current);
      }
      processedInstallments.add(current);
    }

    // Only active items count
    final activeRecurring =
        processedRecurring.where((c) => c.isActive).toList();
    final activeInstallments =
        processedInstallments.where((i) => !i.isCompleted).toList();

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
