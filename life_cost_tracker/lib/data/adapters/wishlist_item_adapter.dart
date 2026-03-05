// wishlist_item_adapter.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 愿与其他愿清单项 Hive 适配器
// Wishlist Item Hive Adapter

import 'package:hive/hive.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/entities/priority.dart';

/// WishlistItem Hive TypeAdapter
/// 愿与其他愿清单项 Hive 类型适配器
class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = 7;

  @override
  WishlistItem read(BinaryReader reader) {
    return WishlistItem(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString()?.isNotEmpty == true
          ? reader.readString()
          : null,
      targetDate: reader.readString()?.isNotEmpty == true
          ? DateTime.parse(reader.readString())
          : null,
      totalCost: reader.readDouble(),
      estimatedUsageDays: reader.readInt(),
      priority: Priority.values[reader.readInt()],
      photoUrl: reader.readString()?.isNotEmpty == true
          ? reader.readString()
          : null,
      linkUrl: reader.readString()?.isNotEmpty == true
          ? reader.readString()
          : null,
      isOwned: reader.readBool(),
      actualUsageDays: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description ?? '');
    writer.writeString(obj.targetDate?.toIso8601String() ?? '');
    writer.writeDouble(obj.totalCost);
    writer.writeInt(obj.estimatedUsageDays ?? 0);
    writer.writeInt(obj.priority.index);
    writer.writeString(obj.photoUrl ?? '');
    writer.writeString(obj.linkUrl ?? '');
    writer.writeBool(obj.isOwned);
    writer.writeInt(obj.actualUsageDays ?? 0);
  }
}
