// credit_account_type_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 信用账户类型 Hive 适配器
// Credit Account Type Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/credit_account_type.dart';

/// CreditAccountType Hive TypeAdapter
/// 信用账户类型 Hive 类型适配器
class CreditAccountTypeAdapter extends TypeAdapter<CreditAccountType> {
  @override
  final int typeId = 3;

  @override
  CreditAccountType read(BinaryReader reader) {
    return CreditAccountType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, CreditAccountType obj) {
    writer.writeInt(obj.index);
  }
}
