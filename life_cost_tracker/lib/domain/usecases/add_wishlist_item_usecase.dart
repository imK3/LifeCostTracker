// add_wishlist_item_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

class AddWishlistItemUseCase implements BaseUseCase<void, WishlistItem> {
  final WishlistItemRepository repository;

  AddWishlistItemUseCase(this.repository);

  @override
  Future<void> call(WishlistItem item) async {
    await repository.addWishlistItem(item);
  }
}
