// billing_cycle_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 账单周期 Hive 适配器
// Billing Cycle Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/billing_cycle.dart';

/// BillingCycle Hive TypeAdapter
/// 账单周期 Hive 类型适配器
class BillingCycleAdapter extends TypeAdapter<BillingCycle> {
  @override
  final int typeId = 5;

  @override
  BillingCycle read(BinaryReader reader) {
    return BillingCycle.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, BillingCycle obj) {
    writer.writeInt(obj.index);
  }
}
