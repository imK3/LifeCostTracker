// simulate_affordability_usecase.dart
// LifeCostTracker
// 承担能力模拟用例
// Affordability simulation use case

import 'base_usecase.dart';
import '../entities/affordability_item.dart';
import 'calculate_sleep_cost_usecase.dart';

/// Result of an affordability simulation
/// 承担能力模拟结果
class AffordabilityResult {
  /// Current daily cost before adding this item
  final double currentDailyCost;

  /// Projected daily cost after adding this item
  final double projectedDailyCost;

  /// Daily increase
  final double dailyIncrease;

  /// Percentage increase
  final double percentageIncrease;

  /// Human-readable recommendation in Chinese
  final String recommendation;

  const AffordabilityResult({
    required this.currentDailyCost,
    required this.projectedDailyCost,
    required this.dailyIncrease,
    required this.percentageIncrease,
    required this.recommendation,
  });
}

/// Simulate the impact of a potential purchase on sleep cost
/// 模拟一笔潜在消费对睡后成本的影响
class SimulateAffordabilityUseCase
    implements BaseUseCase<AffordabilityResult, AffordabilityItem> {
  final CalculateSleepCostUseCase calculateSleepCostUseCase;

  SimulateAffordabilityUseCase({
    required this.calculateSleepCostUseCase,
  });

  @override
  Future<AffordabilityResult> call(AffordabilityItem item) async {
    final currentSummary =
        await calculateSleepCostUseCase.call(NoParams());

    final dailyIncrease = item.dailyImpact;
    final projectedDailyCost =
        currentSummary.totalDailyCost + dailyIncrease;
    final percentageIncrease = currentSummary.totalDailyCost > 0
        ? (dailyIncrease / currentSummary.totalDailyCost) * 100
        : 0.0;

    final recommendation = _generateRecommendation(
      percentageIncrease,
      dailyIncrease,
      item,
    );

    return AffordabilityResult(
      currentDailyCost: currentSummary.totalDailyCost,
      projectedDailyCost: projectedDailyCost,
      dailyIncrease: dailyIncrease,
      percentageIncrease: percentageIncrease,
      recommendation: recommendation,
    );
  }

  String _generateRecommendation(
    double percentageIncrease,
    double dailyIncrease,
    AffordabilityItem item,
  ) {
    // True one-time purchase: not installment and no recurring monthly payment
    if (!item.isInstallment && item.dailyImpact == 0) {
      return '一次性支出不影响你的睡后成本，但会减少你的现金储备。';
    }

    final label = item.isInstallment ? '分期结束前，睡后成本' : '周期性支出将使睡后成本';

    if (percentageIncrease <= 5) {
      return '影响较小，$label仅增加 ${percentageIncrease.toStringAsFixed(1)}%，可以承担。';
    } else if (percentageIncrease <= 15) {
      return '有一定影响，每天多花 ¥${dailyIncrease.toStringAsFixed(2)}，建议评估是否必要。';
    } else if (percentageIncrease <= 30) {
      return '影响较大，$label增加 ${percentageIncrease.toStringAsFixed(1)}%，建议谨慎考虑。';
    } else {
      return '影响显著，$label增加超过 30%，强烈建议重新评估。';
    }
  }
}
