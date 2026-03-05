// subscription_category_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 订阅分类 Hive 适配器
// Subscription Category Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/subscription_category.dart';

/// SubscriptionCategory Hive TypeAdapter
/// 订阅分类 Hive 类型适配器
class SubscriptionCategoryAdapter extends TypeAdapter<SubscriptionCategory> {
  @override
  final int typeId = 6;

  @override
  SubscriptionCategory read(BinaryReader reader) {
    return SubscriptionCategory.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, SubscriptionCategory obj) {
    writer.writeInt(obj.index);
  }
}
