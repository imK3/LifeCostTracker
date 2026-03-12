// hive_installment_plan_repository.dart
// LifeCostTracker
// 分期承诺仓库的 Hive 实现

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/installment_plan.dart';
import '../../domain/repositories/installment_plan_repository.dart';

/// Hive implementation of InstallmentPlanRepository
/// 分期承诺仓库的 Hive 实现
class HiveInstallmentPlanRepository implements InstallmentPlanRepository {
  final Box<InstallmentPlan> _box;

  HiveInstallmentPlanRepository(this._box);

  @override
  Future<List<InstallmentPlan>> getInstallmentPlans() async {
    return _box.values.toList();
  }

  @override
  Future<void> addInstallmentPlan(InstallmentPlan plan) async {
    await _box.put(plan.id, plan);
  }

  @override
  Future<void> updateInstallmentPlan(InstallmentPlan plan) async {
    await _box.put(plan.id, plan);
  }

  @override
  Future<void> deleteInstallmentPlan(String id) async {
    await _box.delete(id);
  }
}
