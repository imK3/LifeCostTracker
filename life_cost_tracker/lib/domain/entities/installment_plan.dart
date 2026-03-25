// installment_plan.dart
// LifeCostTracker
// 分期承诺实体（有终点的固定月供）
// Installment plan entity (fixed monthly payment with an end date)

import 'package:uuid/uuid.dart';
import 'date_utils.dart';

/// Installment plan entity - represents a payment plan with fixed periods
/// 分期承诺实体 - 代表有固定期数的还款计划
///
/// 与 RecurringCost 的唯一区别：有 totalPeriods（截止期数）。
/// 缴费追踪逻辑（nextDueDate, isPaidForCurrentPeriod）完全一致。
class InstallmentPlan {
  /// Unique identifier
  final String id;

  /// Name of the installment
  final String name;

  /// Total amount of the purchase
  final double totalAmount;

  /// Total number of payment periods
  final int totalPeriods;

  /// Number of periods already paid
  final int paidPeriods;

  /// Monthly payment amount
  final double monthlyPayment;

  /// Start date of the installment plan
  final DateTime startDate;

  /// Next due date - when the next payment is due
  /// 下次到期日 — 与 RecurringCost.nextDueDate 语义一致
  final DateTime nextDueDate;

  /// Whether the current period has been paid
  /// 当前周期是否已支付 — 与 RecurringCost.isPaidForCurrentPeriod 语义一致
  final bool isPaidForCurrentPeriod;

  /// Optional notes
  final String? notes;

  /// Calculate daily cost (uses actual days in current month, consistent with RecurringCost)
  double get dailyCost {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return monthlyPayment / daysInMonth;
  }

  /// Remaining amount to pay
  double get remainingAmount =>
      (totalPeriods - paidPeriods) * monthlyPayment;

  /// Remaining periods
  int get remainingPeriods => totalPeriods - paidPeriods;

  /// Whether the plan is fully paid
  bool get isCompleted => paidPeriods >= totalPeriods;

  /// Estimated end date
  DateTime get estimatedEndDate =>
      addMonths(startDate, totalPeriods);

  /// Progress percentage (0.0 - 1.0)
  double get progress =>
      totalPeriods > 0 ? paidPeriods / totalPeriods : 0.0;

  /// Whether payment is overdue (past due date and not paid)
  /// 与 RecurringCost.isOverdue 逻辑一致
  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    return !isPaidForCurrentPeriod && now.isAfter(nextDueDate);
  }

  /// Days until next due date (negative means overdue)
  /// 与 RecurringCost.daysUntilDue 逻辑一致
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

  /// Next period due date (one month forward)
  DateTime get nextPeriodDueDate =>
      addMonths(nextDueDate, 1);

  /// Constructor
  InstallmentPlan({
    String? id,
    required this.name,
    required this.totalAmount,
    required this.totalPeriods,
    required this.paidPeriods,
    required this.monthlyPayment,
    required this.startDate,
    DateTime? nextDueDate,
    this.isPaidForCurrentPeriod = false,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        // 如果没有传入 nextDueDate，从 startDate + paidPeriods 推算
        // paidPeriods=0 时，nextDueDate = startDate（首次到期日）
        // 注意：不能用 startDate + 0 = startDate 然后被自动推进吃掉
        nextDueDate = nextDueDate ??
            (paidPeriods > 0
                ? addMonths(startDate, paidPeriods)
                : startDate);

  /// Create a copy with optional updated values
  InstallmentPlan copyWith({
    String? id,
    String? name,
    double? totalAmount,
    int? totalPeriods,
    int? paidPeriods,
    double? monthlyPayment,
    DateTime? startDate,
    DateTime? nextDueDate,
    bool? isPaidForCurrentPeriod,
    String? notes,
  }) {
    return InstallmentPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPeriods: totalPeriods ?? this.totalPeriods,
      paidPeriods: paidPeriods ?? this.paidPeriods,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isPaidForCurrentPeriod:
          isPaidForCurrentPeriod ?? this.isPaidForCurrentPeriod,
      notes: notes ?? this.notes,
    );
  }

  /// Mark as paid AND advance to next period
  InstallmentPlan payAndAdvance() {
    return copyWith(
      paidPeriods: paidPeriods + 1,
      nextDueDate: nextPeriodDueDate,
      isPaidForCurrentPeriod: false,
    );
  }

  /// Mark current period as paid
  InstallmentPlan markAsPaid() {
    return copyWith(isPaidForCurrentPeriod: true);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
      'totalPeriods': totalPeriods,
      'paidPeriods': paidPeriods,
      'monthlyPayment': monthlyPayment,
      'startDate': startDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'isPaidForCurrentPeriod': isPaidForCurrentPeriod,
      'notes': notes,
    };
  }

  /// Create from JSON
  factory InstallmentPlan.fromJson(Map<String, dynamic> json) {
    return InstallmentPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      totalAmount: json['totalAmount'] as double,
      totalPeriods: json['totalPeriods'] as int,
      paidPeriods: json['paidPeriods'] as int,
      monthlyPayment: json['monthlyPayment'] as double,
      startDate: DateTime.parse(json['startDate'] as String),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'] as String)
          : null,
      isPaidForCurrentPeriod:
          json['isPaidForCurrentPeriod'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}
