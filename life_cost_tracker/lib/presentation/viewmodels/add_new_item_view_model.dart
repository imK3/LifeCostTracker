// add_new_item_view_model.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 添加新物品 ViewModel
// Add New Item ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/entities/priority.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/wishlist_item_repository.dart';

/// Item type to add
/// 要添加的物品类型
enum ItemType {
  /// Wishlist item (not owned yet)
  /// 愿望清单项（尚未拥有）
  wishlist,

  /// Already owned item
  /// 已拥有的物品
  owned,
}

/// Add New Item ViewModel - manages add new item state
/// 添加新物品 ViewModel - 管理添加新物品的状态
class AddNewItemViewModel extends ChangeNotifier {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository _expenseRepository;

  /// Wishlist item repository
  /// 愿望清单仓库
  final WishlistItemRepository _wishlistItemRepository;

  /// Current step (1-3)
  /// 当前步骤 (1-3)
  int _currentStep = 1;

  /// Item type to add
  /// 要添加的物品类型
  ItemType? _itemType;

  /// Item name
  /// 物品名称
  String _name = '';

  /// Item description
  /// 物品描述
  String? _description;

  /// Item category
  /// 物品分类
  ExpenseCategory? _category;

  /// Total cost
  /// 总费用
  double _totalCost = 0;

  /// Estimated usage days
  /// 预计使用天数
  int? _estimatedUsageDays;

  /// Actual usage days (only for owned items)
  /// 实际使用天数（仅已拥有物品）
  int? _actualUsageDays;

  /// Priority (only for wishlist items)
  /// 优先级（仅愿望清单项）
  Priority _priority = Priority.medium;

  /// Photo URL
  /// 照片 URL
  String? _photoUrl;

  /// Link URL
  /// 链接 URL
  String? _linkUrl;

  /// Loading state
  /// 加载状态
  bool _isLoading = false;

  /// Error message
  /// 错误信息
  String? _errorMessage;

  /// Usage day presets
  /// 使用天数预设
  static const List<int> usageDayPresets = [1, 7, 30, 90, 180, 365, 1095];

  /// Constructor
  /// 构造函数
  AddNewItemViewModel({
    required ExpenseRepository expenseRepository,
    required WishlistItemRepository wishlistItemRepository,
  })  : _expenseRepository = expenseRepository,
        _wishlistItemRepository = wishlistItemRepository;

  /// Get current step
  /// 获取当前步骤
  int get currentStep => _currentStep;

  /// Get item type
  /// 获取物品类型
  ItemType? get itemType => _itemType;

  /// Get item name
  /// 获取物品名称
  String get name => _name;

  /// Get item description
  /// 获取物品描述
  String? get description => _description;

  /// Get item category
  /// 获取物品分类
  ExpenseCategory? get category => _category;

  /// Get total cost
  /// 获取总费用
  double get totalCost => _totalCost;

  /// Get estimated usage days
  /// 获取预计使用天数
  int? get estimatedUsageDays => _estimatedUsageDays;

  /// Get actual usage days
  /// 获取实际使用天数
  int? get actualUsageDays => _actualUsageDays;

  /// Get priority
  /// 获取优先级
  Priority get priority => _priority;

  /// Get photo URL
  /// 获取照片 URL
  String? get photoUrl => _photoUrl;

  /// Get link URL
  /// 获取链接 URL
  String? get linkUrl => _linkUrl;

  /// Get loading state
  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// Get error message
  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// Get calculated daily cost
  /// 获取计算后的每日成本
  double? get dailyCost {
    final days = _actualUsageDays ?? _estimatedUsageDays;
    if (days == null || days <= 0 || _totalCost <= 0) return null;
    return _totalCost / days;
  }

  /// Get validation errors
  /// 获取验证错误
  List<String> get validationErrors {
    final errors = <String>[];

    if (_name.trim().isEmpty) {
      errors.add('请输入物品名称');
    }
    if (_totalCost <= 0) {
      errors.add('请输入有效价格');
    }
    if (_itemType == ItemType.wishlist && _estimatedUsageDays == null) {
      errors.add('请输入预计使用天数');
    }
    if (_itemType == ItemType.owned && _actualUsageDays == null) {
      errors.add('请输入实际使用天数');
    }

    return errors;
  }

  /// Check if current step is valid
  /// 检查当前步骤是否有效
  bool get isCurrentStepValid {
    switch (_currentStep) {
      case 1:
        return _itemType != null;
      case 2:
        final days = _actualUsageDays ?? _estimatedUsageDays;
        return days != null && days > 0;
      case 3:
        return validationErrors.isEmpty;
      default:
        return false;
    }
  }

  /// Set item type
  /// 设置物品类型
  void setItemType(ItemType type) {
    if (_itemType != type) {
      _itemType = type;
      notifyListeners();
    }
  }

  /// Set name
  /// 设置名称
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  /// Set description
  /// 设置描述
  void setDescription(String? description) {
    _description = description;
    notifyListeners();
  }

  /// Set category
  /// 设置分类
  void setCategory(ExpenseCategory? category) {
    _category = category;
    notifyListeners();
  }

  /// Set total cost
  /// 设置总费用
  void setTotalCost(double cost) {
    _totalCost = cost;
    notifyListeners();
  }

  /// Set estimated usage days
  /// 设置预计使用天数
  void setEstimatedUsageDays(int? days) {
    _estimatedUsageDays = days;
    notifyListeners();
  }

  /// Set actual usage days
  /// 设置实际使用天数
  void setActualUsageDays(int? days) {
    _actualUsageDays = days;
    notifyListeners();
  }

  /// Set priority
  /// 设置优先级
  void setPriority(Priority priority) {
    _priority = priority;
    notifyListeners();
  }

  /// Set photo URL
  /// 设置照片 URL
  void setPhotoUrl(String? url) {
    _photoUrl = url;
    notifyListeners();
  }

  /// Set link URL
  /// 设置链接 URL
  void setLinkUrl(String? url) {
    _linkUrl = url;
    notifyListeners();
  }

  /// Go to previous step
  /// 回到上一步
  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Go to next step
  /// 进入下一步
  void nextStep() {
    if (_currentStep < 3 && isCurrentStepValid) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Save the item
  /// 保存物品
  Future<void> saveItem() async {
    if (!isCurrentStepValid) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_itemType == ItemType.owned) {
        // Save as expense
        // 保存为支出
        final expense = Expense(
          amount: _totalCost,
          category: _category ?? ExpenseCategory.other,
          notes: _name,
          estimatedUsageDays: _actualUsageDays,
          receiptPhotoUrl: _photoUrl,
        );
        await _expenseRepository.addExpense(expense);
      } else {
        // Save as wishlist item
        // 保存为愿望清单项
        final item = WishlistItem(
          name: _name,
          description: _description,
          totalCost: _totalCost,
          estimatedUsageDays: _estimatedUsageDays,
          priority: _priority,
          photoUrl: _photoUrl,
          linkUrl: _linkUrl,
        );
        await _wishlistItemRepository.addWishlistItem(item);
      }

      // Reset
      // 重置
      reset();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset form
  /// 重置表单
  void reset() {
    _currentStep = 1;
    _itemType = null;
    _name = '';
    _description = null;
    _category = null;
    _totalCost = 0;
    _estimatedUsageDays = null;
    _actualUsageDays = null;
    _priority = Priority.medium;
    _photoUrl = null;
    _linkUrl = null;
    _errorMessage = null;
    notifyListeners();
  }
}
