// expense.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 支出实体
// Expense entity

import 'package:uuid/uuid.dart';
import 'expense_category.dart';

/// Expense entity - represents a single expense
/// 支出实体 - 表示一笔支出
class Expense {
  /// Unique identifier for the expense
  /// 支出的唯一标识符
  final String id;

  /// Amount of the expense
  /// 支出金额
  final double amount;

  /// Category of the expense
  /// 支出分类
  final ExpenseCategory category;

  /// Date of the expense
  /// 支出日期
  final DateTime date;

  /// Optional notes about the expense
  /// 支出的可选备注
  final String? notes;

  /// Optional URL to receipt photo
  /// 收据照片的可选 URL
  final String? receiptPhotoUrl;

  /// Estimated usage days for daily cost calculation
  /// 用于每日成本计算的预计使用天数
  final int? estimatedUsageDays;

  /// Calculate daily cost based on estimated usage days
  /// 根据预计使用天数计算每日成本
  double? get dailyCost {
    if (estimatedUsageDays == null || estimatedUsageDays! <= 0) {
      return null;
    }
    return amount / estimatedUsageDays!;
  }

  /// Create a new Expense
  /// 创建一个新的支出
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

  /// Create a copy of the Expense with optional updated values
  /// 创建一个支出的副本，并可选择更新值
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

  /// Convert Expense to JSON
  /// 将支出转换为 JSON
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

  /// Create Expense from JSON
  /// 从 JSON 创建支出
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
