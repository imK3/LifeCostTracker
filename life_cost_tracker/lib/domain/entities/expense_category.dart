// expense_category.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 支出分类
// Expense category

/// Expense category enum
/// 支出分类枚举
enum ExpenseCategory {
  /// Food and dining
  /// 餐饮
  food,

  /// Transportation
  /// 交通
  transport,

  /// Shopping
  /// 购物
  shopping,

  /// Entertainment
  /// 娱乐
  entertainment,

  /// Utilities and bills
  /// 生活缴费
  utilities,

  /// Other categories
  /// 其他
  other;

  /// Display name for the category in Chinese
  /// 分类的中文显示名称
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return '餐饮';
      case ExpenseCategory.transport:
        return '交通';
      case ExpenseCategory.shopping:
        return '购物';
      case ExpenseCategory.entertainment:
        return '娱乐';
      case ExpenseCategory.utilities:
        return '生活缴费';
      case ExpenseCategory.other:
        return '其他';
    }
  }

  /// System icon name for the category
  /// 分类的系统图标名称
  String get systemIconName {
    switch (this) {
      case ExpenseCategory.food:
        return 'restaurant';
      case ExpenseCategory.transport:
        return 'directions_car';
      case ExpenseCategory.shopping:
        return 'shopping_bag';
      case ExpenseCategory.entertainment:
        return 'gamepad';
      case ExpenseCategory.utilities:
        return 'house';
      case ExpenseCategory.other:
        return 'more_horiz';
    }
  }
}
