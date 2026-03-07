// all_items_list_view_model.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 所有物品列表 ViewModel
// All Items List ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/wishlist_item_repository.dart';

/// Item sorting options
/// 物品排序选项
enum ItemSortOption {
  /// Sort by cost-effectiveness (daily cost / priority)
  /// 按性价比排序（每日成本 / 优先级）
  costEffectiveness,

  /// Sort by daily cost (ascending)
  /// 按每日成本排序（升序）
  dailyCost,

  /// Sort by category
  /// 按分类排序
  category,
}

/// Item filtering options
/// 物品过滤选项
enum ItemFilterOption {
  /// Show all items
  /// 显示所有物品
  all,

  /// Show physical items only
  /// 仅显示实物
  physical,

  /// Show subscriptions only
  /// 仅显示订阅
  subscriptions,

  /// Show cloud services/tools only
  /// 仅显示云服务/工具
  cloudServices,
}

/// Cost-effectiveness tier
/// 性价比等级
enum CostEffectivenessTier {
  /// Divine tier (best cost-effectiveness)
  /// 神仙级（最佳性价比）
  divine,

  /// Excellent tier
  /// 优秀级
  excellent,

  /// Good tier
  /// 良好级
  good,

  /// Fair tier
  /// 一般级
  fair,

  /// Poor tier
  /// 较差级
  poor,
}

/// Display item (combines all item types)
/// 显示物品（组合所有物品类型）
class DisplayItem {
  /// Unique id
  /// 唯一 ID
  final String id;

  /// Name
  /// 名称
  final String name;

  /// Type
  /// 类型
  final String type;

  /// Daily cost
  /// 每日成本
  final double? dailyCost;

  /// Total cost
  /// 总费用
  final double? totalCost;

  /// Category
  /// 分类
  final String? category;

  /// Priority (only for wishlist items)
  /// 优先级（仅愿望清单）
  final String? priority;

  /// Whether it's owned
  /// 是否已拥有
  final bool? isOwned;

  /// Cost-effectiveness tier
  /// 性价比等级
  final CostEffectivenessTier tier;

  DisplayItem({
    required this.id,
    required this.name,
    required this.type,
    required this.tier,
    this.dailyCost,
    this.totalCost,
    this.category,
    this.priority,
    this.isOwned,
  });
}

/// All Items List ViewModel - manages items list state
/// 所有物品列表 ViewModel - 管理物品列表的状态
class AllItemsListViewModel extends ChangeNotifier {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository _expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository _subscriptionRepository;

  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository _wishlistItemRepository;

  /// All display items
  /// 所有显示物品
  List<DisplayItem> _allItems = [];

  /// Filtered and sorted items
  /// 过滤和排序后的物品
  List<DisplayItem> _displayItems = [];

  /// Current sort option
  /// 当前排序选项
  ItemSortOption _sortOption = ItemSortOption.costEffectiveness;

  /// Current filter option
  /// 当前过滤选项
  ItemFilterOption _filterOption = ItemFilterOption.all;

  /// Loading state
  /// 加载状态
  bool _isLoading = false;

  /// Error message
  /// 错误信息
  String? _errorMessage;

  /// Constructor
  /// 构造函数
  AllItemsListViewModel({
    required ExpenseRepository expenseRepository,
    required SubscriptionRepository subscriptionRepository,
    required WishlistItemRepository wishlistItemRepository,
  })  : _expenseRepository = expenseRepository,
        _subscriptionRepository = subscriptionRepository,
        _wishlistItemRepository = wishlistItemRepository;

  /// Get display items
  /// 获取显示物品
  List<DisplayItem> get displayItems => _displayItems;

  /// Get items grouped by cost-effectiveness tier
  /// 获取按性价比等级分组的物品
  Map<CostEffectivenessTier, List<DisplayItem>> get groupedByTier {
    final Map<CostEffectivenessTier, List<DisplayItem>> groups = {};
    for (final tier in CostEffectivenessTier.values) {
      groups[tier] = [];
    }
    for (final item in _displayItems) {
      groups[item.tier]?.add(item);
    }
    return groups;
  }

  /// Get sort option
  /// 获取排序选项
  ItemSortOption get sortOption => _sortOption;

  /// Get filter option
  /// 获取过滤选项
  ItemFilterOption get filterOption => _filterOption;

  /// Get loading state
  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// Get error message
  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// Load all items
  /// 加载所有物品
  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load all data
      // 加载所有数据
      final expenses = await _expenseRepository.getExpenses();
      final subscriptions = await _subscriptionRepository.getSubscriptions();
      final wishlistItems = await _wishlistItemRepository.getWishlistItems();

      // Convert to display items
      // 转换为显示物品
      _allItems = [];
      for (final expense in expenses) {
        _allItems.add(DisplayItem(
          id: expense.id,
          name: expense.notes ?? 'Expense',
          type: 'expense',
          dailyCost: expense.dailyCost,
          totalCost: expense.amount,
          category: expense.category.displayName,
          tier: _calculateTier(expense.dailyCost, null),
        ));
      }
      for (final subscription in subscriptions) {
        _allItems.add(DisplayItem(
          id: subscription.id,
          name: subscription.name,
          type: 'subscription',
          dailyCost: subscription.dailyCost,
          totalCost: subscription.cost,
          category: subscription.category.displayName,
          tier: _calculateTier(subscription.dailyCost, null),
        ));
      }
      for (final item in wishlistItems) {
        _allItems.add(DisplayItem(
          id: item.id,
          name: item.name,
          type: item.isOwned ? 'owned' : 'wishlist',
          dailyCost: item.dailyCost,
          totalCost: item.totalCost,
          priority: item.priority.displayName,
          isOwned: item.isOwned,
          tier: _calculateTier(item.dailyCost, item.priority.index),
        ));
      }

      // Apply filter and sort
      // 应用过滤和排序
      _applyFilterAndSort();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set sort option
  /// 设置排序选项
  void setSortOption(ItemSortOption option) {
    if (_sortOption != option) {
      _sortOption = option;
      _applyFilterAndSort();
      notifyListeners();
    }
  }

  /// Set filter option
  /// 设置过滤选项
  void setFilterOption(ItemFilterOption option) {
    if (_filterOption != option) {
      _filterOption = option;
      _applyFilterAndSort();
      notifyListeners();
    }
  }

  /// Apply filter and sort
  /// 应用过滤和排序
  void _applyFilterAndSort() {
    // Apply filter
    // 应用过滤
    List<DisplayItem> filtered = [];
    switch (_filterOption) {
      case ItemFilterOption.all:
        filtered = List.from(_allItems);
        break;
      case ItemFilterOption.physical:
        filtered = _allItems
            .where((i) => i.type == 'expense' || i.type == 'owned')
            .toList();
        break;
      case ItemFilterOption.subscriptions:
        filtered = _allItems.where((i) => i.type == 'subscription').toList();
        break;
      case ItemFilterOption.cloudServices:
        filtered = _allItems
            .where((i) => i.type == 'subscription' || i.category == '云服务/工具')
            .toList();
        break;
    }

    // Apply sort
    // 应用排序
    switch (_sortOption) {
      case ItemSortOption.costEffectiveness:
        filtered.sort((a, b) => a.tier.index.compareTo(b.tier.index));
        break;
      case ItemSortOption.dailyCost:
        filtered.sort((a, b) => (a.dailyCost ?? double.infinity)
            .compareTo(b.dailyCost ?? double.infinity));
        break;
      case ItemSortOption.category:
        filtered.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
        break;
    }

    _displayItems = filtered;
  }

  /// Calculate cost-effectiveness tier
  /// 计算性价比等级
  CostEffectivenessTier _calculateTier(double? dailyCost, int? priority) {
    if (dailyCost == null) return CostEffectivenessTier.poor;

    // Simple tier calculation (this can be refined)
    // 简单的等级计算（可以进一步优化）
    if (dailyCost < 1) return CostEffectivenessTier.divine;
    if (dailyCost < 5) return CostEffectivenessTier.excellent;
    if (dailyCost < 20) return CostEffectivenessTier.good;
    if (dailyCost < 100) return CostEffectivenessTier.fair;
    return CostEffectivenessTier.poor;
  }
}
