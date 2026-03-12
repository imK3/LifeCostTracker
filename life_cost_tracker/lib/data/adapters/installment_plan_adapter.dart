// installment_plan_adapter.dart
// LifeCostTracker
// 分期承诺 Hive 适配器

import 'package:hive/hive.dart';
import '../../domain/entities/installment_plan.dart';

/// InstallmentPlan Hive TypeAdapter
class InstallmentPlanAdapter extends TypeAdapter<InstallmentPlan> {
  @override
  final int typeId = 12;

  @override
  InstallmentPlan read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final totalAmount = reader.readDouble();
    final totalPeriods = reader.readInt();
    final paidPeriods = reader.readInt();
    final monthlyPayment = reader.readDouble();
    final startDate = DateTime.parse(reader.readString());
    final notes = reader.readString();

    return InstallmentPlan(
      id: id,
      name: name,
      totalAmount: totalAmount,
      totalPeriods: totalPeriods,
      paidPeriods: paidPeriods,
      monthlyPayment: monthlyPayment,
      startDate: startDate,
      notes: notes.isNotEmpty ? notes : null,
    );
  }

  @override
  void write(BinaryWriter writer, InstallmentPlan obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.totalAmount);
    writer.writeInt(obj.totalPeriods);
    writer.writeInt(obj.paidPeriods);
    writer.writeDouble(obj.monthlyPayment);
    writer.writeString(obj.startDate.toIso8601String());
    writer.writeString(obj.notes ?? '');
  }
}
