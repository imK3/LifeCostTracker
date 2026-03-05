// expense_category.dart
// LifeCostTracker
// Created by LifeCostTracker Team

enum ExpenseCategory {
  food,
  transport,
  shopping,
  entertainment,
  utilities,
  other;

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
