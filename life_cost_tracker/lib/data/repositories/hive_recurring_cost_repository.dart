// hive_recurring_cost_repository.dart
// LifeCostTracker
// 周期性成本仓库的 Hive 实现

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/repositories/recurring_cost_repository.dart';

/// Hive implementation of RecurringCostRepository
/// 周期性成本仓库的 Hive 实现
class HiveRecurringCostRepository implements RecurringCostRepository {
  final Box<RecurringCost> _box;

  HiveRecurringCostRepository(this._box);

  @override
  Future<List<RecurringCost>> getRecurringCosts() async {
    return _box.values.toList();
  }

  @override
  Future<void> addRecurringCost(RecurringCost cost) async {
    await _box.put(cost.id, cost);
  }

  @override
  Future<void> updateRecurringCost(RecurringCost cost) async {
    await _box.put(cost.id, cost);
  }

  @override
  Future<void> deleteRecurringCost(String id) async {
    await _box.delete(id);
  }
}
