// hive_wishlist_item_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// Hive 愿与其他愿清单项仓库实现
// Hive Wishlist Item Repository Implementation

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_item_repository.dart';

/// Hive implementation of WishlistItemRepository
/// 愿与其他愿清单项仓库的 Hive 实现
class HiveWishlistItemRepository implements WishlistItemRepository {
  /// Hive box for wishlist items
  /// 愿与其他愿清单项的 Hive 盒子
  final Box<WishlistItem> _wishlistItemBox;

  /// Constructor
  /// 构造函数
  HiveWishlistItemRepository(this._wishlistItemBox);

  /// Get all wishlist items
  /// 获取所有愿望清单项
  @override
  Future<List<WishlistItem>> getWishlistItems() async {
    return _wishlistItemBox.values.toList();
  }

  /// Add a new wishlist item
  /// 添加新愿望清单项
  @override
  Future<void> addWishlistItem(WishlistItem item) async {
    await _wishlistItemBox.put(item.id, item);
  }

  /// Update an existing wishlist item
  /// 更新现有愿望清单项
  @override
  Future<void> updateWishlistItem(WishlistItem item) async {
    await _wishlistItemBox.put(item.id, item);
  }

  /// Delete a wishlist item by id
  /// 根据 ID 删除愿望清单项
  @override
  Future<void> deleteWishlistItem(String id) async {
    await _wishlistItemBox.delete(id);
  }
}
