// display_cycle.dart
// LifeCostTracker
// 展示周期（用户偏好：按日/月/年查看成本）
// Display cycle (user preference: view cost per day/month/year)

/// Display cycle enum - controls how costs are displayed to the user
/// 展示周期枚举 - 控制成本的展示方式
enum DisplayCycle {
  /// Daily display
  /// 每日
  daily,

  /// Monthly display
  /// 每月
  monthly,

  /// Yearly display
  /// 每年
  yearly;

  /// Display name in Chinese
  /// 中文显示名称
  String get displayName {
    switch (this) {
      case DisplayCycle.daily:
        return '每日';
      case DisplayCycle.monthly:
        return '每月';
      case DisplayCycle.yearly:
        return '每年';
    }
  }

  /// Multiplier from daily cost to this cycle's cost
  /// 从日成本转换到该周期成本的乘数
  int get daysMultiplier {
    switch (this) {
      case DisplayCycle.daily:
        return 1;
      case DisplayCycle.monthly:
        return 30;
      case DisplayCycle.yearly:
        return 365;
    }
  }

  /// Format label for display
  /// 展示标签
  String get unitLabel {
    switch (this) {
      case DisplayCycle.daily:
        return '天';
      case DisplayCycle.monthly:
        return '月';
      case DisplayCycle.yearly:
        return '年';
    }
  }
}
