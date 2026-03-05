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
    return CreditAccount(
      id: reader.readString(),
      name: reader.readString(),
      type: CreditAccountType.values[reader.readInt()],
      balance: reader.readDouble(),
      creditLimit: reader.readDouble(),
      apr: reader.readDouble(),
      dueDate: reader.readString()?.isNotEmpty == true
          ? DateTime.parse(reader.readString())
          : null,
      minimumPayment: reader.readDouble(),
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
