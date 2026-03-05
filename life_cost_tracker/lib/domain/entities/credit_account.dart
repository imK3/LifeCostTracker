// credit_account.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 信用账户实体
// Credit account entity

import 'package:uuid/uuid.dart';
import 'credit_account_type.dart';

/// Credit account entity - represents a credit card, loan, or installment plan
/// 信用账户实体 - 表示信用卡、贷款或分期付款计划
class CreditAccount {
  /// Unique identifier for the credit account
  /// 信用账户的唯一标识符
  final String id;

  /// Name of the credit account
  /// 信用账户名称
  final String name;

  /// Type of the credit account
  /// 信用账户类型
  final CreditAccountType type;

  /// Current balance of the credit account
  /// 信用账户当前余额
  final double balance;

  /// Credit limit of the credit account (if applicable)
  /// 信用账户的信用额度（如适用）
  final double? creditLimit;

  /// Annual percentage rate (APR) of the credit account
  /// 信用账户的年利率 (APR)
  final double? apr;

  /// Due date for the next payment
  /// 下一次付款的到期日
  final DateTime? dueDate;

  /// Minimum payment required for the credit account
  /// 信用账户的最低还款额
  final double? minimumPayment;

  /// Calculate credit utilization percentage
  /// 计算信用利用率百分比
  double? get creditUtilization {
    if (creditLimit == null || creditLimit! <= 0) {
      return null;
    }
    return balance / creditLimit!;
  }

  /// Create a new CreditAccount
  /// 创建一个新的信用账户
  CreditAccount({
    String? id,
    required this.name,
    required this.type,
    required this.balance,
    this.creditLimit,
    this.apr,
    this.dueDate,
    this.minimumPayment,
  }) : id = id ?? const Uuid().v4();

  /// Create a copy of the CreditAccount with optional updated values
  /// 创建一个信用账户的副本，并可选择更新值
  CreditAccount copyWith({
    String? id,
    String? name,
    CreditAccountType? type,
    double? balance,
    double? creditLimit,
    double? apr,
    DateTime? dueDate,
    double? minimumPayment,
  }) {
    return CreditAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      creditLimit: creditLimit ?? this.creditLimit,
      apr: apr ?? this.apr,
      dueDate: dueDate ?? this.dueDate,
      minimumPayment: minimumPayment ?? this.minimumPayment,
    );
  }

  /// Convert CreditAccount to JSON
  /// 将信用账户转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'balance': balance,
      'creditLimit': creditLimit,
      'apr': apr,
      'dueDate': dueDate?.toIso8601String(),
      'minimumPayment': minimumPayment,
    };
  }

  /// Create CreditAccount from JSON
  /// 从 JSON 创建信用账户
  factory CreditAccount.fromJson(Map<String, dynamic> json) {
    return CreditAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CreditAccountType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CreditAccountType.creditCard,
      ),
      balance: json['balance'] as double,
      creditLimit: json['creditLimit'] as double?,
      apr: json['apr'] as double?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      minimumPayment: json['minimumPayment'] as double?,
    );
  }
}
