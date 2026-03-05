// wishlist_item_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';

/// Wishlist item repository interface
/// 愿望清单仓库接口
abstract class WishlistItemRepository {
  /// Get all wishlist items
  /// 获取所有愿望清单项
  Future<List<WishlistItem>> getWishlistItems();

  /// Add a new wishlist item
  /// 添加新愿望清单项
  Future<void> addWishlistItem(WishlistItem item);

  /// Update an existing wishlist item
  /// 更新现有愿望清单项
  Future<void> updateWishlistItem(WishlistItem item);

  /// Delete a wishlist item by id
  /// 根据 ID 删除愿望清单项
  Future<void> deleteWishlistItem(String id);
}
