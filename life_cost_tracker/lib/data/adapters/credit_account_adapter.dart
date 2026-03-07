// credit_account_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 信用账户 Hive 适配器
// Credit Account Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/credit_account.dart';
import '../../domain/entities/credit_account_type.dart';

/// CreditAccount Hive TypeAdapter
/// 信用账户 Hive 类型适配器
class CreditAccountAdapter extends TypeAdapter<CreditAccount> {
  @override
  final int typeId = 2;

  @override
  CreditAccount read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final type = CreditAccountType.values[reader.readInt()];
    final balance = reader.readDouble();
    final creditLimit = reader.readDouble();
    final apr = reader.readDouble();
    final dueDateStr = reader.readString();
    final minimumPayment = reader.readDouble();

    return CreditAccount(
      id: id,
      name: name,
      type: type,
      balance: balance,
      creditLimit: creditLimit > 0 ? creditLimit : null,
      apr: apr > 0 ? apr : null,
      dueDate: dueDateStr.isNotEmpty ? DateTime.parse(dueDateStr) : null,
      minimumPayment: minimumPayment > 0 ? minimumPayment : null,
    );
  }

  @override
  void write(BinaryWriter writer, CreditAccount obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.type.index);
    writer.writeDouble(obj.balance);
    writer.writeDouble(obj.creditLimit ?? 0);
    writer.writeDouble(obj.apr ?? 0);
    writer.writeString(obj.dueDate?.toIso8601String() ?? '');
    writer.writeDouble(obj.minimumPayment ?? 0);
  }
}
