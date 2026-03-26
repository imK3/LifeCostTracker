// affordability_item.dart
// LifeCostTracker
// 承担能力模拟实体
// Affordability simulation item entity

import 'package:uuid/uuid.dart';

/// Affordability item entity - used for "can I afford this?" simulation
/// 承担能力模拟实体 - 用于"我能负担得起吗？"模拟
class AffordabilityItem {
  /// Unique identifier
  /// 唯一标识符
  final String id;

  /// Name of the item
  /// 商品名称
  final String name;

  /// Total cost of the item
  /// 总价
  final double totalCost;

  /// Whether this would be paid in installments
  /// 是否分期付款
  final bool isInstallment;

  /// Number of installment periods (if applicable)
  /// 分期期数（如适用）
  final int? installmentPeriods;

  /// Monthly payment (if installment)
  /// 月供金额（如分期）
  final double? monthlyPayment;

  /// Optional notes
  /// 备注
  final String? notes;

  /// Daily cost impact if purchased
  /// 如果购买，对每日成本的影响
  double get dailyImpact {
    // Recurring expense with monthlyPayment
    if (!isInstallment && monthlyPayment != null && monthlyPayment! > 0) {
      return monthlyPayment! / 30;
    }
    // Installment
    if (isInstallment) {
      return (monthlyPayment ?? (totalCost / (installmentPeriods ?? 1))) / 30;
    }
    // One-time purchase, no recurring impact
    return 0;
  }

  /// Monthly cost impact
  /// 月度成本影响
  double get monthlyImpact {
    if (!isInstallment && monthlyPayment != null && monthlyPayment! > 0) {
      return monthlyPayment!;
    }
    if (isInstallment) {
      return monthlyPayment ?? (totalCost / (installmentPeriods ?? 1));
    }
    return 0;
  }

  /// Constructor
  AffordabilityItem({
    String? id,
    required this.name,
    required this.totalCost,
    this.isInstallment = false,
    this.installmentPeriods,
    this.monthlyPayment,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  /// Create a copy with optional updated values
  AffordabilityItem copyWith({
    String? id,
    String? name,
    double? totalCost,
    bool? isInstallment,
    int? installmentPeriods,
    double? monthlyPayment,
    String? notes,
  }) {
    return AffordabilityItem(
      id: id ?? this.id,
      name: name ?? this.name,
      totalCost: totalCost ?? this.totalCost,
      isInstallment: isInstallment ?? this.isInstallment,
      installmentPeriods: installmentPeriods ?? this.installmentPeriods,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalCost': totalCost,
      'isInstallment': isInstallment,
      'installmentPeriods': installmentPeriods,
      'monthlyPayment': monthlyPayment,
      'notes': notes,
    };
  }

  /// Create from JSON
  factory AffordabilityItem.fromJson(Map<String, dynamic> json) {
    return AffordabilityItem(
      id: json['id'] as String,
      name: json['name'] as String,
      totalCost: json['totalCost'] as double,
      isInstallment: json['isInstallment'] as bool? ?? false,
      installmentPeriods: json['installmentPeriods'] as int?,
      monthlyPayment: json['monthlyPayment'] != null
          ? (json['monthlyPayment'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }
}
