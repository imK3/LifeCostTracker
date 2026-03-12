// installment_plan.dart
// LifeCostTracker
// 分期承诺实体（有终点的固定月供）
// Installment plan entity (fixed monthly payment with an end date)

import 'package:uuid/uuid.dart';

/// Installment plan entity - represents a payment plan with fixed periods
/// 分期承诺实体 - 代表有固定期数的还款计划
class InstallmentPlan {
  /// Unique identifier
  /// 唯一标识符
  final String id;

  /// Name of the installment
  /// 分期名称
  final String name;

  /// Total amount of the purchase
  /// 总金额
  final double totalAmount;

  /// Total number of payment periods
  /// 总期数
  final int totalPeriods;

  /// Number of periods already paid
  /// 已还期数
  final int paidPeriods;

  /// Monthly payment amount
  /// 每月还款额
  final double monthlyPayment;

  /// Start date of the installment plan
  /// 分期开始日期
  final DateTime startDate;

  /// Optional notes
  /// 备注
  final String? notes;

  /// Calculate daily cost
  /// 计算每日成本
  double get dailyCost => monthlyPayment / 30;

  /// Remaining amount to pay
  /// 剩余待还金额
  double get remainingAmount =>
      (totalPeriods - paidPeriods) * monthlyPayment;

  /// Remaining periods
  /// 剩余期数
  int get remainingPeriods => totalPeriods - paidPeriods;

  /// Whether the plan is fully paid
  /// 是否已还清
  bool get isCompleted => paidPeriods >= totalPeriods;

  /// Estimated end date
  /// 预计结束日期
  DateTime get estimatedEndDate =>
      DateTime(startDate.year, startDate.month + totalPeriods, startDate.day);

  /// Progress percentage (0.0 - 1.0)
  /// 还款进度（0.0 - 1.0）
  double get progress =>
      totalPeriods > 0 ? paidPeriods / totalPeriods : 0.0;

  /// Constructor
  InstallmentPlan({
    String? id,
    required this.name,
    required this.totalAmount,
    required this.totalPeriods,
    required this.paidPeriods,
    required this.monthlyPayment,
    required this.startDate,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  /// Create a copy with optional updated values
  InstallmentPlan copyWith({
    String? id,
    String? name,
    double? totalAmount,
    int? totalPeriods,
    int? paidPeriods,
    double? monthlyPayment,
    DateTime? startDate,
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
      notes: notes ?? this.notes,
    );
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
      notes: json['notes'] as String?,
    );
  }
}
