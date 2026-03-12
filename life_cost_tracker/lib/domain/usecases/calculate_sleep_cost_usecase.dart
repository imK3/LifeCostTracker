// calculate_sleep_cost_usecase.dart
// LifeCostTracker
// 核心用例：计算睡后成本
// Core use case: calculate sleep cost

import 'base_usecase.dart';
import '../entities/recurring_cost.dart';
import '../entities/installment_plan.dart';
import '../entities/sleep_cost_summary.dart';
import '../repositories/recurring_cost_repository.dart';
import '../repositories/installment_plan_repository.dart';

/// Calculate the total "sleep cost" - how much you owe when you wake up
/// 计算总"睡后成本" - 醒来时你欠了多少
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

    // Filter active items only
    final activeRecurring =
        recurringCosts.where((c) => c.isActive).toList();
    final activeInstallments =
        installments.where((i) => !i.isCompleted).toList();

    // Split recurring costs into fixed living and subscriptions
    final fixedLivingItems =
        activeRecurring.where((c) => c.isFixedLiving).toList();
    final subscriptionItems =
        activeRecurring.where((c) => c.isSubscription).toList();

    // Calculate daily costs for each category
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
    );
  }
}
