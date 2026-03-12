// manage_recurring_cost_usecase.dart
// LifeCostTracker
// 周期性成本 CRUD 用例

import '../entities/recurring_cost.dart';
import '../repositories/recurring_cost_repository.dart';

/// Add a recurring cost
/// 添加周期性成本
class AddRecurringCostUseCase {
  final RecurringCostRepository repository;

  AddRecurringCostUseCase({required this.repository});

  Future<void> call(RecurringCost cost) async {
    await repository.addRecurringCost(cost);
  }
}

/// Get all recurring costs
/// 获取所有周期性成本
class GetRecurringCostsUseCase {
  final RecurringCostRepository repository;

  GetRecurringCostsUseCase({required this.repository});

  Future<List<RecurringCost>> call() async {
    return await repository.getRecurringCosts();
  }
}

/// Update a recurring cost
/// 更新周期性成本
class UpdateRecurringCostUseCase {
  final RecurringCostRepository repository;

  UpdateRecurringCostUseCase({required this.repository});

  Future<void> call(RecurringCost cost) async {
    await repository.updateRecurringCost(cost);
  }
}

/// Delete a recurring cost
/// 删除周期性成本
class DeleteRecurringCostUseCase {
  final RecurringCostRepository repository;

  DeleteRecurringCostUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteRecurringCost(id);
  }
}
