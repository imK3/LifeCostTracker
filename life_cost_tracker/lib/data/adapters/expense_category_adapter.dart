// expense_category_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 支出分类 Hive 适配器
// Expense Category Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/expense_category.dart';

/// ExpenseCategory Hive TypeAdapter
/// 支出分类 Hive 类型适配器
class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 1;

  @override
  ExpenseCategory read(BinaryReader reader) {
    return ExpenseCategory.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer.writeInt(obj.index);
  }
}
