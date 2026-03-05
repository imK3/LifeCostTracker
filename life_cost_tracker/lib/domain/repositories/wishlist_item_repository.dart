// wishlist_item_repository.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';

abstract class WishlistItemRepository {
  Future<List<WishlistItem>> getWishlistItems();
  Future<void> addWishlistItem(WishlistItem item);
  Future<void> updateWishlistItem(WishlistItem item);
  Future<void> deleteWishlistItem(String id);
}
