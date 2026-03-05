// priority_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 优先级 Hive 适配器
// Priority Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/priority.dart';

/// Priority Hive TypeAdapter
/// 优先级 Hive 类型适配器
class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 8;

  @override
  Priority read(BinaryReader reader) {
    return Priority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    writer.writeInt(obj.index);
  }
}
