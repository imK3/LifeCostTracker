// compare_wishlist_daily_costs_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 比较愿望清单每日成本用例
// Compare wishlist daily costs use case

import '../entities/wishlist_item.dart';
import '../repositories/wishlist_item_repository.dart';
import 'base_usecase.dart';

/// Wishlist item daily cost comparison
/// 愿与其他愿清单项每日成本比较
class WishlistDailyCostComparison {
  /// Item A
  /// 物品 A
  final WishlistItem itemA;

  /// Item B
  /// 物品 B
  final WishlistItem itemB;

  /// Item A daily cost
  /// 物品 A 每日成本
  final double? itemADailyCost;

  /// Item B daily cost
  /// 物品 B 每日成本
  final double? itemBDailyCost;

  /// Cost difference (A - B)
  /// 成本差异 (A - B)
  double? get costDifference {
    if (itemADailyCost == null || itemBDailyCost == null) return null;
    return itemADailyCost! - itemBDailyCost!;
  }

  /// Which item is more cost-effective (lower daily cost)
  /// 哪个物品更具成本效益（每日成本更低）
  String get moreCostEffective {
    if (itemADailyCost == null || itemBDailyCost == null) return 'Cannot compare';
    if (itemADailyCost! < itemBDailyCost!) return 'Item A';
    if (itemADailyCost! > itemBDailyCost!) return 'Item B';
    return 'Equal';
  }

  /// Cost difference percentage
  /// 成本差异百分比
  double? get costDifferencePercentage {
    if (itemADailyCost == null || itemBDailyCost == null) return null;
    if (itemBDailyCost == 0) return null;
    return (itemADailyCost! - itemBDailyCost!) / itemBDailyCost!;
  }

  WishlistDailyCostComparison({
    required this.itemA,
    required this.itemB,
    required this.itemADailyCost,
    required this.itemBDailyCost,
  });
}

/// Compare wishlist daily costs use case
/// 比较愿望清单每日成本用例
class CompareWishlistDailyCostsUseCase
    implements BaseUseCase<WishlistDailyCostComparison, List<WishlistItem>> {
  /// Wishlist item repository
  /// 愿与其他愿清单仓库
  final WishlistItemRepository wishlistItemRepository;

  /// Constructor
  /// 构造函数
  CompareWishlistDailyCostsUseCase(this.wishlistItemRepository);

  /// Execute * use case to compare two wishlist items
  /// 执行用例以比较两个愿望清单项
  @override
  Future<WishlistDailyCostComparison> call(List<WishlistItem> items) async {
    if (items.length != 2) {
      throw ArgumentError('Must provide exactly 2 items to compare');
    }

    final itemA = items[0];
    final itemB = items[1];

    return WishlistDailyCostComparison(
      itemA: itemA,
      itemB: itemB,
      itemADailyCost: itemA.dailyCost,
      itemBDailyCost: itemB.dailyCost,
    );
  }
}
