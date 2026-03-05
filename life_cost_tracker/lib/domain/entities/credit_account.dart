// credit_account.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import 'package:uuid/uuid.dart';
import 'credit_account_type.dart';

class CreditAccount {
  final String id;
  final String name;
  final CreditAccountType type;
  final double balance;
  final double? creditLimit;
  final double? apr;
  final DateTime? dueDate;
  final double? minimumPayment;

  double? get creditUtilization {
    if (creditLimit == null || creditLimit! <= 0) {
      return null;
    }
    return balance / creditLimit!;
  }

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
