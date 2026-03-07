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
    final id = reader.readString();
    final amount = reader.readDouble();
    final category = ExpenseCategory.values[reader.readInt()];
    final date = DateTime.parse(reader.readString());
    final notes = reader.readString();
    final receiptPhotoUrl = reader.readString();
    final estimatedUsageDays = reader.readInt();

    return Expense(
      id: id,
      amount: amount,
      category: category,
      date: date,
      notes: notes.isNotEmpty ? notes : null,
      receiptPhotoUrl: receiptPhotoUrl.isNotEmpty ? receiptPhotoUrl : null,
      estimatedUsageDays: estimatedUsageDays > 0 ? estimatedUsageDays : null,
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
