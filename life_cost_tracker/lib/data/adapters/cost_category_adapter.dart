// cost_category_adapter.dart
// LifeCostTracker
// 成本分类 Hive 适配器

import 'package:hive/hive.dart';
import '../../domain/entities/cost_category.dart';

/// CostCategory Hive TypeAdapter
class CostCategoryAdapter extends TypeAdapter<CostCategory> {
  @override
  final int typeId = 11;

  @override
  CostCategory read(BinaryReader reader) {
    return CostCategory.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, CostCategory obj) {
    writer.writeInt(obj.index);
  }
}
