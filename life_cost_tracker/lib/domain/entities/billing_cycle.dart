// billing_cycle.dart
// LifeCostTracker
// 账单周期
// Billing cycle

/// Billing cycle enum
/// 账单周期枚举
enum BillingCycle {
  /// Weekly billing
  /// 每周
  weekly,

  /// Monthly billing
  /// 每月
  monthly,

  /// Quarterly billing
  /// 每季度
  quarterly,

  /// Yearly billing
  /// 每年
  yearly;

  /// Display name for the billing cycle in Chinese
  /// 账单周期的中文显示名称
  String get displayName {
    switch (this) {
      case BillingCycle.weekly:
        return '每周';
      case BillingCycle.monthly:
        return '每月';
      case BillingCycle.quarterly:
        return '每季度';
      case BillingCycle.yearly:
        return '每年';
    }
  }

  /// Number of days in the billing cycle
  /// 账单周期的天数
  int get daysInCycle {
    switch (this) {
      case BillingCycle.weekly:
        return 7;
      case BillingCycle.monthly:
        return 30;
      case BillingCycle.quarterly:
        return 90;
      case BillingCycle.yearly:
        return 365;
    }
  }
}
