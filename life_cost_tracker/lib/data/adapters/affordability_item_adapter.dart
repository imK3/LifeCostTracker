// affordability_item_adapter.dart
// LifeCostTracker
// 承担能力模拟项 Hive 适配器

import 'package:hive/hive.dart';
import '../../domain/entities/affordability_item.dart';

/// AffordabilityItem Hive TypeAdapter
class AffordabilityItemAdapter extends TypeAdapter<AffordabilityItem> {
  @override
  final int typeId = 13;

  @override
  AffordabilityItem read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final totalCost = reader.readDouble();
    final isInstallment = reader.readBool();
    final installmentPeriods = reader.readInt();
    final monthlyPayment = reader.readDouble();
    final notes = reader.readString();

    return AffordabilityItem(
      id: id,
      name: name,
      totalCost: totalCost,
      isInstallment: isInstallment,
      installmentPeriods: installmentPeriods > 0 ? installmentPeriods : null,
      monthlyPayment: monthlyPayment > 0 ? monthlyPayment : null,
      notes: notes.isNotEmpty ? notes : null,
    );
  }

  @override
  void write(BinaryWriter writer, AffordabilityItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.totalCost);
    writer.writeBool(obj.isInstallment);
    writer.writeInt(obj.installmentPeriods ?? 0);
    writer.writeDouble(obj.monthlyPayment ?? 0);
    writer.writeString(obj.notes ?? '');
  }
}
