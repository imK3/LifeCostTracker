// affordability_item_repository.dart
// LifeCostTracker
// 承担能力模拟项仓库接口

import '../entities/affordability_item.dart';

/// Affordability item repository interface
/// 承担能力模拟项仓库接口
abstract class AffordabilityItemRepository {
  /// Get all affordability items
  Future<List<AffordabilityItem>> getAffordabilityItems();

  /// Add a new affordability item
  Future<void> addAffordabilityItem(AffordabilityItem item);

  /// Update an existing affordability item
  Future<void> updateAffordabilityItem(AffordabilityItem item);

  /// Delete an affordability item by id
  Future<void> deleteAffordabilityItem(String id);
}
