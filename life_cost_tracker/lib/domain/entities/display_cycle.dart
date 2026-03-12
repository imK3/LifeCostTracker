// display_cycle.dart
// LifeCostTracker
// 展示周期（用户偏好：按日/月/季/年查看成本）

/// Display cycle enum - controls how costs are displayed to the user
/// 展示周期枚举 - 控制成本的展示方式
enum DisplayCycle {
  /// 每日
  daily,

  /// 每月
  monthly,

  /// 每季度
  quarterly,

  /// 每年
  yearly;

  /// Display name in Chinese
  String get displayName {
    switch (this) {
      case DisplayCycle.daily:
        return '每日';
      case DisplayCycle.monthly:
        return '每月';
      case DisplayCycle.quarterly:
        return '每季度';
      case DisplayCycle.yearly:
        return '每年';
    }
  }

  /// Actual calendar days for this cycle based on current date
  /// 基于当前日期的实际日历天数
  int get actualDays {
    final now = DateTime.now();
    switch (this) {
      case DisplayCycle.daily:
        return 1;
      case DisplayCycle.monthly:
        // Actual days in current month
        return DateTime(now.year, now.month + 1, 0).day;
      case DisplayCycle.quarterly:
        // Actual days in current quarter
        final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
        final quarterStart = DateTime(now.year, quarterStartMonth, 1);
        final quarterEnd = DateTime(now.year, quarterStartMonth + 3, 1);
        return quarterEnd.difference(quarterStart).inDays;
      case DisplayCycle.yearly:
        // Actual days in current year (handles leap year)
        return DateTime(now.year + 1, 1, 1)
            .difference(DateTime(now.year, 1, 1))
            .inDays;
    }
  }

  /// Format label for display
  String get unitLabel {
    switch (this) {
      case DisplayCycle.daily:
        return '天';
      case DisplayCycle.monthly:
        return '月';
      case DisplayCycle.quarterly:
        return '季';
      case DisplayCycle.yearly:
        return '年';
    }
  }
}
