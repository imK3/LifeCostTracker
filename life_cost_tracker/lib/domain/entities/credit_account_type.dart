// credit_account_type.dart
// LifeCostTracker
// Created by LifeCostTracker Team

enum CreditAccountType {
  creditCard,
  personalLoan,
  studentLoan,
  installmentPlan;

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
