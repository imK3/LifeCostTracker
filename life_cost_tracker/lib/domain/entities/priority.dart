// priority.dart
// LifeCostTracker
// Created by LifeCostTracker Team

enum Priority implements Comparable<Priority> {
  low(1),
  medium(2),
  high(3);

  final int value;

  const Priority(this.value);

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

  @override
  int compareTo(Priority other) {
    return value.compareTo(other.value);
  }
}
