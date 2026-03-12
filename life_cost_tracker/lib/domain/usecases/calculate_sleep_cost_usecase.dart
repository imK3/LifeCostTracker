// calculate_sleep_cost_usecase.dart
// LifeCostTracker
// 核心用例：计算睡后成本
// Core use case: calculate sleep cost

import 'base_usecase.dart';
import '../entities/sleep_cost_summary.dart';
import '../repositories/recurring_cost_repository.dart';
import '../repositories/installment_plan_repository.dart';

/// Calculate the total "sleep cost" — your daily burn rate
///
/// 睡后成本 = 你的生活燃烧率
/// 所有 active 的周期性成本都计入，不管本期是否已支付。
/// 因为房租付了这个月，下个月还要付；保险付了今年，明年还要续。
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

    // Split by category (for display)
    final fixedLivingItems =
        activeRecurring.where((c) => c.isFixedLiving).toList();
    final subscriptionItems =
        activeRecurring.where((c) => c.isSubscription).toList();

    // Split by payment status (for UI tracking)
    final unpaidFixedLiving =
        fixedLivingItems.where((c) => !c.isPaidForCurrentPeriod).toList();
    final paidFixedLiving =
        fixedLivingItems.where((c) => c.isPaidForCurrentPeriod).toList();
    final unpaidSubscription =
        subscriptionItems.where((c) => !c.isPaidForCurrentPeriod).toList();
    final paidSubscription =
        subscriptionItems.where((c) => c.isPaidForCurrentPeriod).toList();

    // ALL active items count toward sleep cost (burn rate)
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
      unpaidFixedLivingItems: unpaidFixedLiving,
      unpaidSubscriptionItems: unpaidSubscription,
      paidFixedLivingItems: paidFixedLiving,
      paidSubscriptionItems: paidSubscription,
      installmentItems: activeInstallments,
    );
  }
}
