// installment_plan_adapter.dart
// LifeCostTracker
// 分期承诺 Hive 适配器

import 'package:hive/hive.dart';
import '../../domain/entities/installment_plan.dart';

/// InstallmentPlan Hive TypeAdapter
///
/// 新增字段 nextDueDate 和 isPaidForCurrentPeriod（v2）
/// 兼容旧数据：读取时如果没有新字段，自动从 startDate + paidPeriods 推算
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

    // v2 新增字段，兼容旧数据
    DateTime? nextDueDate;
    bool isPaidForCurrentPeriod = false;
    bool isOldFormat = false;
    try {
      final nextDueDateStr = reader.readString();
      if (nextDueDateStr.isNotEmpty) {
        nextDueDate = DateTime.parse(nextDueDateStr);
      }
      isPaidForCurrentPeriod = reader.readBool();
    } catch (_) {
      isOldFormat = true;
    }

    // 旧数据迁移：如果有已付期数且推算出的 nextDueDate 在未来，说明本期已缴
    if (isOldFormat && paidPeriods > 0) {
      // 安全日期计算：避免2月31等溢出
      final targetMonth = startDate.month + paidPeriods;
      final maxDay = DateTime(startDate.year, targetMonth + 1, 0).day;
      final clampedDay = startDate.day > maxDay ? maxDay : startDate.day;
      final computed = DateTime(startDate.year, targetMonth, clampedDay);
      if (computed.isAfter(DateTime.now())) {
        isPaidForCurrentPeriod = true;
      }
    }

    return InstallmentPlan(
      id: id,
      name: name,
      totalAmount: totalAmount,
      totalPeriods: totalPeriods,
      paidPeriods: paidPeriods,
      monthlyPayment: monthlyPayment,
      startDate: startDate,
      nextDueDate: nextDueDate,
      isPaidForCurrentPeriod: isPaidForCurrentPeriod,
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
    // v2 新增字段
    writer.writeString(obj.nextDueDate.toIso8601String());
    writer.writeBool(obj.isPaidForCurrentPeriod);
  }
}
