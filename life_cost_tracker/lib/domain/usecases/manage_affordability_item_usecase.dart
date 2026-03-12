// manage_affordability_item_usecase.dart
// LifeCostTracker
// 承担能力模拟项 CRUD 用例

import '../entities/affordability_item.dart';
import '../repositories/affordability_item_repository.dart';

/// Add an affordability item
/// 添加模拟项
class AddAffordabilityItemUseCase {
  final AffordabilityItemRepository repository;

  AddAffordabilityItemUseCase({required this.repository});

  Future<void> call(AffordabilityItem item) async {
    await repository.addAffordabilityItem(item);
  }
}

/// Get all affordability items
/// 获取所有模拟项
class GetAffordabilityItemsUseCase {
  final AffordabilityItemRepository repository;

  GetAffordabilityItemsUseCase({required this.repository});

  Future<List<AffordabilityItem>> call() async {
    return await repository.getAffordabilityItems();
  }
}

/// Delete an affordability item
/// 删除模拟项
class DeleteAffordabilityItemUseCase {
  final AffordabilityItemRepository repository;

  DeleteAffordabilityItemUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteAffordabilityItem(id);
  }
}
