// calculate_sleep_cost_usecase.dart
// LifeCostTracker
// 核心用例：计算睡后成本
// Core use case: calculate sleep cost

import 'base_usecase.dart';
import '../entities/sleep_cost_summary.dart';
import '../repositories/recurring_cost_repository.dart';
import '../repositories/installment_plan_repository.dart';

/// Calculate the total "sleep cost" - only unpaid items count
/// 计算总"睡后成本" - 只有未支付的项才算
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
    final installments = await installmentPlanRepository.getInstallmentPlans();

    // Filter active items
    final activeRecurring =
        recurringCosts.where((c) => c.isActive).toList();
    final activeInstallments =
        installments.where((i) => !i.isCompleted).toList();

    // Split into paid and unpaid
    final unpaidRecurring =
        activeRecurring.where((c) => !c.isPaidForCurrentPeriod).toList();
    final paidRecurring =
        activeRecurring.where((c) => c.isPaidForCurrentPeriod).toList();

    // Split unpaid by category
    final fixedLivingItems =
        unpaidRecurring.where((c) => c.isFixedLiving).toList();
    final subscriptionItems =
        unpaidRecurring.where((c) => c.isSubscription).toList();

    // Split paid by category
    final paidFixedLivingItems =
        paidRecurring.where((c) => c.isFixedLiving).toList();
    final paidSubscriptionItems =
        paidRecurring.where((c) => c.isSubscription).toList();

    // Only unpaid items count toward sleep cost
    final fixedLivingDaily =
        fixedLivingItems.fold<double>(0, (sum, c) => sum + c.dailyCost);
    final subscriptionDaily =
        subscriptionItems.fold<double>(0, (sum, c) => sum + c.dailyCost);
    final installmentDaily =
        activeInstallments.fold<double>(0, (sum, i) => sum + i.dailyCost);

    return SleepCostSummary(
      totalDailyCost: fixedLivingDaily + subscriptionDaily + installmentDaily,
      fixedLivingDaily: fixedLivingDaily,
      subscriptionDaily: subscriptionDaily,
      installmentDaily: installmentDaily,
      fixedLivingItems: fixedLivingItems,
      subscriptionItems: subscriptionItems,
      installmentItems: activeInstallments,
      paidFixedLivingItems: paidFixedLivingItems,
      paidSubscriptionItems: paidSubscriptionItems,
    );
  }
}
