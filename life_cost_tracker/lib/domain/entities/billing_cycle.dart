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

  /// Label for the due date input field
  /// 到期日输入框的标签
  String get dueDateLabel {
    switch (this) {
      case BillingCycle.weekly:
        return '每周付款日';
      case BillingCycle.monthly:
        return '每月付款日';
      case BillingCycle.quarterly:
        return '每季度付款日';
      case BillingCycle.yearly:
        return '每年付款日';
    }
  }

  /// Hint text for the due date input field
  /// 到期日输入框的提示文字
  String get dueDateHint {
    switch (this) {
      case BillingCycle.weekly:
        return '周几付款（1=周一，7=周日）';
      case BillingCycle.monthly:
        return '每月几号付款';
      case BillingCycle.quarterly:
        return '每季度几号付款';
      case BillingCycle.yearly:
        return '每年几月付款（1-12）';
    }
  }

  /// Suffix text for the due date input field
  /// 到期日输入框的后缀
  String get dueDateSuffix {
    switch (this) {
      case BillingCycle.weekly:
        return '';
      case BillingCycle.monthly:
        return '号';
      case BillingCycle.quarterly:
        return '号';
      case BillingCycle.yearly:
        return '月';
    }
  }

  /// Validate and clamp the due day value for this cycle
  /// 校验并限制到期日值
  int clampDueDay(int value) {
    switch (this) {
      case BillingCycle.weekly:
        return value.clamp(1, 7);
      case BillingCycle.monthly:
        return value.clamp(1, 31);
      case BillingCycle.quarterly:
        return value.clamp(1, 31);
      case BillingCycle.yearly:
        return value.clamp(1, 12);
    }
  }
}
