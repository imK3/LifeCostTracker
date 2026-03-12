// recurring_cost_adapter.dart
// LifeCostTracker
// 周期性成本 Hive 适配器

import 'package:hive/hive.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/cost_category.dart';

/// RecurringCost Hive TypeAdapter
class RecurringCostAdapter extends TypeAdapter<RecurringCost> {
  @override
  final int typeId = 10;

  @override
  RecurringCost read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final amount = reader.readDouble();
    final billingCycle = BillingCycle.values[reader.readInt()];
    final category = CostCategory.values[reader.readInt()];
    final startDate = DateTime.parse(reader.readString());
    final endDateStr = reader.readString();
    final isActive = reader.readBool();
    final notes = reader.readString();

    return RecurringCost(
      id: id,
      name: name,
      amount: amount,
      billingCycle: billingCycle,
      category: category,
      startDate: startDate,
      endDate: endDateStr.isNotEmpty ? DateTime.parse(endDateStr) : null,
      isActive: isActive,
      notes: notes.isNotEmpty ? notes : null,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringCost obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.billingCycle.index);
    writer.writeInt(obj.category.index);
    writer.writeString(obj.startDate.toIso8601String());
    writer.writeString(obj.endDate?.toIso8601String() ?? '');
    writer.writeBool(obj.isActive);
    writer.writeString(obj.notes ?? '');
  }
}
