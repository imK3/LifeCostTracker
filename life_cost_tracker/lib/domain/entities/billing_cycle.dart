// billing_cycle.dart
// LifeCostTracker
// Created by LifeCostTracker Team

enum BillingCycle {
  weekly,
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case BillingCycle.weekly:
        return '每周';
      case BillingCycle.monthly:
        return '每月';
      case BillingCycle.yearly:
        return '每年';
    }
  }

  int get daysInCycle {
    switch (this) {
      case BillingCycle.weekly:
        return 7;
      case BillingCycle.monthly:
        return 30;
      case BillingCycle.yearly:
        return 365;
    }
  }
}
