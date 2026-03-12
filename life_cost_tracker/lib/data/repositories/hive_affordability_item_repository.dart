// hive_affordability_item_repository.dart
// LifeCostTracker
// 承担能力模拟项仓库的 Hive 实现

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/affordability_item.dart';
import '../../domain/repositories/affordability_item_repository.dart';

/// Hive implementation of AffordabilityItemRepository
/// 承担能力模拟项仓库的 Hive 实现
class HiveAffordabilityItemRepository implements AffordabilityItemRepository {
  final Box<AffordabilityItem> _box;

  HiveAffordabilityItemRepository(this._box);

  @override
  Future<List<AffordabilityItem>> getAffordabilityItems() async {
    return _box.values.toList();
  }

  @override
  Future<void> addAffordabilityItem(AffordabilityItem item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> updateAffordabilityItem(AffordabilityItem item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> deleteAffordabilityItem(String id) async {
    await _box.delete(id);
  }
}
