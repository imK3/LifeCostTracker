// priority.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 优先级
// Priority

/// Priority enum for wishlist items
/// 愿望清单项的优先级枚举
enum Priority implements Comparable<Priority> {
  /// Low priority
  /// 低优先级
  low(1),

  /// Medium priority
  /// 中优先级
  medium(2),

  /// High priority
  /// 高优先级
  high(3);

  /// Numeric value of the priority
  /// 优先级的数值
  final int value;

  const Priority(this.value);

  /// Display name for the priority in Chinese
  /// 优先级的中文显示名称
  String get displayName {
    switch (this) {
      case Priority.low:
        return '低';
      case Priority.medium:
        return '中';
      case Priority.high:
        return '高';
    }
  }

  /// System icon name for the priority
  /// 优先级的系统图标名称
  String get systemIconName {
    switch (this) {
      case Priority.low:
        return 'flag';
      case Priority.medium:
        return 'outlined_flag';
      case Priority.high:
        return 'priority_high';
    }
  }

  /// Compare priorities
  /// 比较优先级
  @override
  int compareTo(Priority other) {
    return value.compareTo(other.value);
  }
}
