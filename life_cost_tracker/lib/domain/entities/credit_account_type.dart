// credit_account_type.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 信用账户类型
// Credit account type

/// Credit account type enum
/// 信用账户类型枚举
enum CreditAccountType {
  /// Credit card
  /// 信用卡
  creditCard,

  /// Personal loan
  /// 个人贷款
  personalLoan,

  /// Student loan
  /// 学生贷款
  studentLoan,

  /// Installment plan
  /// 分期付款
  installmentPlan;

  /// Display name for the credit account type in Chinese
  /// 信用账户类型的中文显示名称
  String get displayName {
    switch (this) {
      case CreditAccountType.creditCard:
        return '信用卡';
      case CreditAccountType.personalLoan:
        return '个人贷款';
      case CreditAccountType.studentLoan:
        return '学生贷款';
      case CreditAccountType.installmentPlan:
        return '分期付款';
    }
  }

  /// System icon name for the credit account type
  /// 信用账户类型的系统图标名称
  String get systemIconName {
    switch (this) {
      case CreditAccountType.creditCard:
        return 'credit_card';
      case CreditAccountType.personalLoan:
        return 'account_balance_wallet';
      case CreditAccountType.studentLoan:
        return 'school';
      case CreditAccountType.installmentPlan:
        return 'calendar_today';
    }
  }
}
