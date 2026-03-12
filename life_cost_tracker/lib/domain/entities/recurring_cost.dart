// recurring_cost.dart
// LifeCostTracker
// 周期性成本实体（统一固定生活成本和订阅费用）
// Recurring cost entity (unified for fixed living costs and subscriptions)

import 'package:uuid/uuid.dart';
import 'billing_cycle.dart';
import 'cost_category.dart';

/// Recurring cost entity - represents any periodic expense
/// 周期性成本实体 - 代表任何周期性支出
class RecurringCost {
  /// Unique identifier
  final String id;

  /// Name of the cost item
  /// 成本项名称
  final String name;

  /// Amount per billing cycle
  /// 每个账单周期的金额
  final double amount;

  /// Billing cycle
  /// 账单周期
  final BillingCycle billingCycle;

  /// Category of the cost
  /// 成本分类
  final CostCategory category;

  /// Start date of this cost
  /// 开始日期
  final DateTime startDate;

  /// End date (null means ongoing)
  /// 结束日期（null 表示持续中）
  final DateTime? endDate;

  /// Next due date - when the next payment is due
  /// 下次到期日 - 下次需要付款的日期
  final DateTime nextDueDate;

  /// Whether the current period has been paid
  /// 当前周期是否已支付
  final bool isPaidForCurrentPeriod;

  /// Whether this cost is currently active
  /// 是否当前生效
  final bool isActive;

  /// Optional notes
  /// 备注
  final String? notes;

  /// Calculate daily cost
  /// 计算每日成本
  double get dailyCost => amount / billingCycle.daysInCycle;

  /// Calculate monthly equivalent cost
  double get monthlyCost => dailyCost * 30;

  /// Calculate yearly equivalent cost
  double get yearlyCost => dailyCost * 365;

  /// Whether this is a fixed living cost
  bool get isFixedLiving => category.isFixedLiving;

  /// Whether this is a subscription
  bool get isSubscription => category.isSubscription;

  /// Whether payment is overdue (past due date and not paid)
  /// 是否逾期（过了到期日但未支付）
  bool get isOverdue {
    final now = DateTime.now();
    return !isPaidForCurrentPeriod &&
        now.isAfter(nextDueDate);
  }

  /// Days until next due date (negative means overdue)
  /// 距离下次到期还有几天（负数表示逾期）
  int get daysUntilDue {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final due = DateTime(
      nextDueDate.year,
      nextDueDate.month,
      nextDueDate.day,
    );
    return due.difference(now).inDays;
  }

  /// Calculate the next due date after marking current period as paid
  /// 标记当前周期已支付后，计算下一个到期日
  DateTime get nextPeriodDueDate {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return DateTime(
          nextDueDate.year,
          nextDueDate.month,
          nextDueDate.day + 7,
        );
      case BillingCycle.monthly:
        return DateTime(
          nextDueDate.year,
          nextDueDate.month + 1,
          nextDueDate.day,
        );
      case BillingCycle.quarterly:
        return DateTime(
          nextDueDate.year,
          nextDueDate.month + 3,
          nextDueDate.day,
        );
      case BillingCycle.yearly:
        return DateTime(
          nextDueDate.year + 1,
          nextDueDate.month,
          nextDueDate.day,
        );
    }
  }

  /// Constructor
  RecurringCost({
    String? id,
    required this.name,
    required this.amount,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    required this.nextDueDate,
    this.endDate,
    this.isPaidForCurrentPeriod = false,
    this.isActive = true,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  /// Create a copy with optional updated values
  RecurringCost copyWith({
    String? id,
    String? name,
    double? amount,
    BillingCycle? billingCycle,
    CostCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextDueDate,
    bool? isPaidForCurrentPeriod,
    bool? isActive,
    String? notes,
  }) {
    return RecurringCost(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isPaidForCurrentPeriod:
          isPaidForCurrentPeriod ?? this.isPaidForCurrentPeriod,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  /// Mark as paid: set isPaidForCurrentPeriod = true
  /// 标记已支付
  RecurringCost markAsPaid() {
    return copyWith(isPaidForCurrentPeriod: true);
  }

  /// Advance to next period: move nextDueDate forward, reset paid status
  /// 推进到下一个周期：到期日前移，重置支付状态
  RecurringCost advanceToNextPeriod() {
    return copyWith(
      nextDueDate: nextPeriodDueDate,
      isPaidForCurrentPeriod: false,
    );
  }

  /// Mark as paid AND advance to next period in one step
  /// 支付并推进到下一个周期
  RecurringCost payAndAdvance() {
    return copyWith(
      nextDueDate: nextPeriodDueDate,
      isPaidForCurrentPeriod: false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'billingCycle': billingCycle.name,
      'category': category.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'isPaidForCurrentPeriod': isPaidForCurrentPeriod,
      'isActive': isActive,
      'notes': notes,
    };
  }

  /// Create from JSON
  factory RecurringCost.fromJson(Map<String, dynamic> json) {
    return RecurringCost(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as double,
      billingCycle: BillingCycle.values.firstWhere(
        (e) => e.name == json['billingCycle'],
        orElse: () => BillingCycle.monthly,
      ),
      category: CostCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => CostCategory.other,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      isPaidForCurrentPeriod:
          json['isPaidForCurrentPeriod'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
    );
  }
}
