// recurring_cost_repository.dart
// LifeCostTracker
// 周期性成本仓库接口

import '../entities/recurring_cost.dart';

/// Recurring cost repository interface
/// 周期性成本仓库接口
abstract class RecurringCostRepository {
  /// Get all recurring costs
  Future<List<RecurringCost>> getRecurringCosts();

  /// Add a new recurring cost
  Future<void> addRecurringCost(RecurringCost cost);

  /// Update an existing recurring cost
  Future<void> updateRecurringCost(RecurringCost cost);

  /// Delete a recurring cost by id
  Future<void> deleteRecurringCost(String id);
}
