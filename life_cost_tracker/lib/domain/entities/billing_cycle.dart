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

  /// Actual calendar days in the current billing cycle
  /// 当前账单周期的实际日历天数
  int get daysInCycle {
    final now = DateTime.now();
    switch (this) {
      case BillingCycle.weekly:
        return 7;
      case BillingCycle.monthly:
        return DateTime(now.year, now.month + 1, 0).day;
      case BillingCycle.quarterly:
        final qStart = ((now.month - 1) ~/ 3) * 3 + 1;
        return DateTime(now.year, qStart + 3, 1)
            .difference(DateTime(now.year, qStart, 1))
            .inDays;
      case BillingCycle.yearly:
        return DateTime(now.year + 1, 1, 1)
            .difference(DateTime(now.year, 1, 1))
            .inDays;
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

  /// Number of months in this cycle (for multiplier calculation)
  /// 周期包含的月数（用于倍数计算）
  int get monthsInCycle {
    switch (this) {
      case BillingCycle.weekly:
        return 0; // 特殊处理：周付用天数计算
      case BillingCycle.monthly:
        return 1;
      case BillingCycle.quarterly:
        return 3;
      case BillingCycle.yearly:
        return 12;
    }
  }

  /// Calculate multiplier from basePeriod to this billingCycle
  /// 计算从基础周期到账单周期的倍数
  /// 例如：basePeriod=monthly, billingCycle=quarterly → 3
  double multiplierFrom(BillingCycle basePeriod) {
    if (this == basePeriod) return 1.0;
    // 用天数比来计算，兼容 weekly
    return daysInCycle / basePeriod.daysInCycle;
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
