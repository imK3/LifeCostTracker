// expense_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 支出 Hive 适配器
// Expense Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

/// Expense Hive TypeAdapter
/// 支出 Hive 类型适配器
class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      id: reader.readString(),
      amount: reader.readDouble(),
      category: ExpenseCategory.values[reader.readInt()],
      date: DateTime.parse(reader.readString()),
      notes: reader.readString(),
      receiptPhotoUrl: reader.readString(),
      estimatedUsageDays: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.category.index);
    writer.writeString(obj.date.toIso8601String());
    writer.writeString(obj.notes ?? '');
    writer.writeString(obj.receiptPhotoUrl ?? '');
    writer.writeInt(obj.estimatedUsageDays ?? 0);
  }
}
