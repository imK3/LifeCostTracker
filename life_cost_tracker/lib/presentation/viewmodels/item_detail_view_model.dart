// item_detail_view_model.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 物品详情 ViewModel
// Item Detail ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/wishlist_item_repository.dart';

/// Item type for detail view
/// 详情视图的物品类型
enum DetailItemType {
  /// Expense
  /// 支出
  expense,

  /// Subscription
  /// 订阅
  subscription,

  /// Wishlist item (not owned)
  /// 愿望清单项（未拥有）
  wishlist,

  /// Owned item
  /// 已拥有的物品
  owned,
}

/// Item Detail ViewModel - manages item detail state
/// 物品详情 ViewModel - 管理物品详情的状态
class ItemDetailViewModel extends ChangeNotifier {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository _expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository _subscriptionRepository;

  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository _wishlistItemRepository;

  /// Item type
  /// 物品类型
  DetailItemType? _itemType;

  /// Expense (if type is expense)
  /// 支出（如果类型是支出）
  Expense? _expense;

  /// Subscription (if type is subscription)
  /// 订阅（如果类型是订阅）
  Subscription? _subscription;

  /// Wishlist item (if type is wishlist or owned)
  /// 愿望清单项（如果类型是愿望清单或已拥有）
  WishlistItem? _wishlistItem;

  /// Is editing
  /// 是否在编辑中
  bool _isEditing = false;

  /// Edit form data
  /// 编辑表单数据
  Map<String, dynamic> _editData = {};

  /// Loading state
  /// 加载状态
  bool _isLoading = false;

  /// Error message
  /// 错误信息
  String? _errorMessage;

  /// Constructor
  /// 构造函数
  ItemDetailViewModel({
    required ExpenseRepository expenseRepository,
    required SubscriptionRepository subscriptionRepository,
    required WishlistItemRepository wishlistItemRepository,
  })  : _expenseRepository = expenseRepository,
        _subscriptionRepository = subscriptionRepository,
        _wishlistItemRepository = wishlistItemRepository;

  /// Get item type
  /// 获取物品类型
  DetailItemType? get itemType => _itemType;

  /// Get expense
  /// 获取支出
  Expense? get expense => _expense;

  /// Get subscription
  /// 获取订阅
  Subscription? get subscription => _subscription;

  /// Get wishlist item
  /// 获取愿望清单项
  WishlistItem? get wishlistItem => _wishlistItem;

  /// Get is editing
  /// 获取是否在编辑中
  bool get isEditing => _isEditing;

  /// Get edit data
  /// 获取编辑数据
  Map<String, dynamic> get editData => Map.unmodifiable(_editData);

  /// Get loading state
  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// Get error message
  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// Get item name
  /// 获取物品名称
  String? get itemName {
    switch (_itemType) {
      case DetailItemType.expense:
        return _expense?.notes ?? '支出';
      case DetailItemType.subscription:
        return _subscription?.name;
      case DetailItemType.wishlist:
      case DetailItemType.owned:
        return _wishlistItem?.name;
      default:
        return null;
    }
  }

  /// Get daily cost
  /// 获取每日成本
  double? get dailyCost {
    switch (_itemType) {
      case DetailItemType.expense:
        return _expense?.dailyCost;
      case DetailItemType.subscription:
        return _subscription?.dailyCost;
      case DetailItemType.wishlist:
      case DetailItemType.owned:
        return _wishlistItem?.dailyCost;
      default:
        return null;
    }
  }

  /// Load an expense
  /// 加载支出
  Future<void> loadExpense(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final expenses = await _expenseRepository.getExpenses();
      _expense = expenses.firstWhere((e) => e.id == id);
      _itemType = DetailItemType.expense;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load a subscription
  /// 加载订阅
  Future<void> loadSubscription(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final subscriptions = await _subscriptionRepository.getSubscriptions();
      _subscription = subscriptions.firstWhere((s) => s.id == id);
      _itemType = DetailItemType.subscription;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load a wishlist item
  /// 加载愿望清单项
  Future<void> loadWishlistItem(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final items = await _wishlistItemRepository.getWishlistItems();
      _wishlistItem = items.firstWhere((i) => i.id == id);
      _itemType = _wishlistItem!.isOwned
          ? DetailItemType.owned
          : DetailItemType.wishlist;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Start editing
  /// 开始编辑
  void startEditing() {
    _isEditing = true;
    _editData = {};

    // Pre-populate edit data
    // 预填充编辑数据
    switch (_itemType) {
      case DetailItemType.expense:
        _editData['name'] = _expense?.notes ?? '';
        _editData['amount'] = _expense?.amount ?? 0;
        _editData['estimatedUsageDays'] = _expense?.estimatedUsageDays;
        break;
      case DetailItemType.subscription:
        _editData['name'] = _subscription?.name ?? '';
        _editData['cost'] = _subscription?.cost ?? 0;
        break;
      case DetailItemType.wishlist:
      case DetailItemType.owned:
        _editData['name'] = _wishlistItem?.name ?? '';
        _editData['totalCost'] = _wishlistItem?.totalCost ?? 0;
        _editData['estimatedUsageDays'] = _wishlistItem?.estimatedUsageDays;
        _editData['priority'] = _wishlistItem?.priority;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  /// Update edit field
  /// 更新编辑字段
  void updateEditField(String field, dynamic value) {
    _editData[field] = value;
    notifyListeners();
  }

  /// Cancel editing
  /// 取消编辑
  void cancelEditing() {
    _isEditing = false;
    _editData = {};
    notifyListeners();
  }

  /// Save edits
  /// 保存编辑
  Future<void> saveEdits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      switch (_itemType) {
        case DetailItemType.expense:
          final updated = _expense!.copyWith(
            notes: _editData['name'] as String?,
            amount: _editData['amount'] as double?,
            estimatedUsageDays: _editData['estimatedUsageDays'] as int?,
          );
          await _expenseRepository.updateExpense(updated);
          _expense = updated;
          break;
        case DetailItemType.subscription:
          final updated = _subscription!.copyWith(
            name: _editData['name'] as String?,
            cost: _editData['cost'] as double?,
          );
          await _subscriptionRepository.updateSubscription(updated);
          _subscription = updated;
          break;
        case DetailItemType.wishlist:
        case DetailItemType.owned:
          final updated = _wishlistItem!.copyWith(
            name: _editData['name'] as String?,
            totalCost: _editData['totalCost'] as double?,
            estimatedUsageDays: _editData['estimatedUsageDays'] as int?,
            priority: _editData['priority'] as dynamic,
          );
          await _wishlistItemRepository.updateWishlistItem(updated);
          _wishlistItem = updated;
          break;
        default:
          break;
      }

      _isEditing = false;
      _editData = {};
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete item
  /// 删除物品
  Future<void> deleteItem() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      switch (_itemType) {
        case DetailItemType.expense:
          await _expenseRepository.deleteExpense(_expense!.id);
          break;
        case DetailItemType.subscription:
          await _subscriptionRepository.deleteSubscription(_subscription!.id);
          break;
        case DetailItemType.wishlist:
        case DetailItemType.owned:
          await _wishlistItemRepository.deleteWishlistItem(_wishlistItem!.id);
          break;
        default:
          break;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark as sold/gone
  /// 标记为已出售/已处理
  Future<void> markAsSoldGone() async {
    if (_itemType != DetailItemType.owned) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _wishlistItem!.copyWith(
        isOwned: false,
      );
      await _wishlistItemRepository.updateWishlistItem(updated);
      _wishlistItem = updated;
      _itemType = DetailItemType.wishlist;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
