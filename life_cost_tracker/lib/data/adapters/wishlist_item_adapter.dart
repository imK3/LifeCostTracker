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
    final id = reader.readString();
    final name = reader.readString();
    final descriptionStr = reader.readString();
    final targetDateStr = reader.readString();
    final totalCost = reader.readDouble();
    final estimatedUsageDays = reader.readInt();
    final priority = Priority.values[reader.readInt()];
    final photoUrlStr = reader.readString();
    final linkUrlStr = reader.readString();
    final isOwned = reader.readBool();
    final actualUsageDays = reader.readInt();

    return WishlistItem(
      id: id,
      name: name,
      description: descriptionStr.isNotEmpty ? descriptionStr : null,
      targetDate:
          targetDateStr.isNotEmpty ? DateTime.parse(targetDateStr) : null,
      totalCost: totalCost,
      estimatedUsageDays: estimatedUsageDays > 0 ? estimatedUsageDays : null,
      priority: priority,
      photoUrl: photoUrlStr.isNotEmpty ? photoUrlStr : null,
      linkUrl: linkUrlStr.isNotEmpty ? linkUrlStr : null,
      isOwned: isOwned,
      actualUsageDays: actualUsageDays > 0 ? actualUsageDays : null,
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
