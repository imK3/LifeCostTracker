// installment_plan_repository.dart
// LifeCostTracker
// 分期承诺仓库接口

import '../entities/installment_plan.dart';

/// Installment plan repository interface
/// 分期承诺仓库接口
abstract class InstallmentPlanRepository {
  /// Get all installment plans
  Future<List<InstallmentPlan>> getInstallmentPlans();

  /// Add a new installment plan
  Future<void> addInstallmentPlan(InstallmentPlan plan);

  /// Update an existing installment plan
  Future<void> updateInstallmentPlan(InstallmentPlan plan);

  /// Delete an installment plan by id
  Future<void> deleteInstallmentPlan(String id);
}
