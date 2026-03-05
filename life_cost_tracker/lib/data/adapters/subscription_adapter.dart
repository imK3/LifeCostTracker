// subscription_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 订阅 Hive 适配器
// Subscription Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/subscription_category.dart';

/// Subscription Hive TypeAdapter
/// 订阅 Hive 类型适配器
class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 4;

  @override
  Subscription read(BinaryReader reader) {
    return Subscription(
      id: reader.readString(),
      name: reader.readString(),
      cost: reader.readDouble(),
      billingCycle: BillingCycle.values[reader.readInt()],
      nextBillingDate: DateTime.parse(reader.readString()),
      category: SubscriptionCategory.values[reader.readInt()],
      isFreeTrial: reader.readBool(),
      freeTrialEndDate: reader.readString()?.isNotEmpty == true
          ? DateTime.parse(reader.readString())
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.cost);
    writer.writeInt(obj.billingCycle.index);
    writer.writeString(obj.nextBillingDate.toIso8601String());
    writer.writeInt(obj.category.index);
    writer.writeBool(obj.isFreeTrial);
    writer.writeString(obj.freeTrialEndDate?.toIso8601String() ?? '');
  }
}
