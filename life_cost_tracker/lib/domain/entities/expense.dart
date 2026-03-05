// expense.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import 'package:uuid/uuid.dart';
import 'expense_category.dart';

class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes;
  final String? receiptPhotoUrl;
  final int? estimatedUsageDays;

  double? get dailyCost {
    if (estimatedUsageDays == null || estimatedUsageDays! <= 0) {
      return null;
    }
    return amount / estimatedUsageDays!;
  }

  Expense({
    String? id,
    required this.amount,
    required this.category,
    DateTime? date,
    this.notes,
    this.receiptPhotoUrl,
    this.estimatedUsageDays,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? notes,
    String? receiptPhotoUrl,
    int? estimatedUsageDays,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptPhotoUrl: receiptPhotoUrl ?? this.receiptPhotoUrl,
      estimatedUsageDays: estimatedUsageDays ?? this.estimatedUsageDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
      'notes': notes,
      'receiptPhotoUrl': receiptPhotoUrl,
      'estimatedUsageDays': estimatedUsageDays,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      amount: json['amount'] as double,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      receiptPhotoUrl: json['receiptPhotoUrl'] as String?,
      estimatedUsageDays: json['estimatedUsageDays'] as int?,
    );
  }
}
