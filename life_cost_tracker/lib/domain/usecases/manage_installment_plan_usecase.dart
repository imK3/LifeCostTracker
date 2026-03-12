// manage_installment_plan_usecase.dart
// LifeCostTracker
// 分期承诺 CRUD 用例

import '../entities/installment_plan.dart';
import '../repositories/installment_plan_repository.dart';

/// Add an installment plan
/// 添加分期承诺
class AddInstallmentPlanUseCase {
  final InstallmentPlanRepository repository;

  AddInstallmentPlanUseCase({required this.repository});

  Future<void> call(InstallmentPlan plan) async {
    await repository.addInstallmentPlan(plan);
  }
}

/// Get all installment plans
/// 获取所有分期承诺
class GetInstallmentPlansUseCase {
  final InstallmentPlanRepository repository;

  GetInstallmentPlansUseCase({required this.repository});

  Future<List<InstallmentPlan>> call() async {
    return await repository.getInstallmentPlans();
  }
}

/// Update an installment plan
/// 更新分期承诺
class UpdateInstallmentPlanUseCase {
  final InstallmentPlanRepository repository;

  UpdateInstallmentPlanUseCase({required this.repository});

  Future<void> call(InstallmentPlan plan) async {
    await repository.updateInstallmentPlan(plan);
  }
}

/// Delete an installment plan
/// 删除分期承诺
class DeleteInstallmentPlanUseCase {
  final InstallmentPlanRepository repository;

  DeleteInstallmentPlanUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteInstallmentPlan(id);
  }
}
