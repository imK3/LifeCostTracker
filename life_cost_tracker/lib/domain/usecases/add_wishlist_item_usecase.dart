// add_wishlist_item_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/wishlist_item.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

/// Add wishlist item use case
/// 添加愿望清单项用例
class AddWishlistItemUseCase implements BaseUseCase<void, WishlistItem> {
  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository wishlistItemRepository;

  /// Constructor
  /// 构造函数
  AddWishlistItemUseCase({required this.wishlistItemRepository});

  /// Execute the use case
  /// 执行用例
  @override
  Future<void> call(WishlistItem item) async {
    await wishlistItemRepository.addWishlistItem(item);
  }
}
