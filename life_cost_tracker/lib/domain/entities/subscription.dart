// subscription.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 订阅实体
// Subscription entity

import 'package:uuid/uuid.dart';
import 'billing_cycle.dart';
import 'subscription_category.dart';

/// Subscription entity - represents a subscription service
/// 订阅实体 - 表示一个订阅服务
class Subscription {
  /// Unique identifier for the subscription
  /// 订阅的唯一标识符
  final String id;

  /// Name of the subscription
  /// 订阅名称
  final String name;

  /// Cost of the subscription
  /// 订阅费用
  final double cost;

  /// Billing cycle of the subscription
  /// 订阅的账单周期
  final BillingCycle billingCycle;

  /// Next billing date of the subscription
  /// 订阅的下一个账单日期
  final DateTime nextBillingDate;

  /// Category of the subscription
  /// 订阅分类
  final SubscriptionCategory category;

  /// Whether the subscription is in free trial
  /// 订阅是否处于免费试用期
  final bool isFreeTrial;

  /// End date of the free trial (if applicable)
  /// 免费试用期结束日期（如适用）
  final DateTime? freeTrialEndDate;

  /// Calculate daily cost of the subscription
  /// 计算订阅的每日成本
  double get dailyCost {
    return cost / billingCycle.daysInCycle;
  }

  /// Create a new Subscription
  /// 创建一个新的订阅
  Subscription({
    String? id,
    required this.name,
    required this.cost,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    this.isFreeTrial = false,
    this.freeTrialEndDate,
  }) : id = id ?? const Uuid().v4();

  /// Create a copy of the Subscription with optional updated values
  /// 创建一个订阅的副本，并可选择更新值
  Subscription copyWith({
    String? id,
    String? name,
    double? cost,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    SubscriptionCategory? category,
    bool? isFreeTrial,
    DateTime? freeTrialEndDate,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      freeTrialEndDate: freeTrialEndDate ?? this.freeTrialEndDate,
    );
  }

  /// Convert Subscription to JSON
  /// 将订阅转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'billingCycle': billingCycle.name,
      'nextBillingDate': nextBillingDate.toIso8601String(),
      'category': category.name,
      'isFreeTrial': isFreeTrial,
      'freeTrialEndDate': freeTrialEndDate?.toIso8601String(),
    };
  }

  /// Create Subscription from JSON
  /// 从 JSON 创建订阅
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      cost: json['cost'] as double,
      billingCycle: BillingCycle.values.firstWhere(
        (e) => e.name == json['billingCycle'],
        orElse: () => BillingCycle.monthly,
      ),
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      category: SubscriptionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => SubscriptionCategory.other,
      ),
      isFreeTrial: json['isFreeTrial'] as bool? ?? false,
      freeTrialEndDate: json['freeTrialEndDate'] != null
          ? DateTime.parse(json['freeTrialEndDate'] as String)
          : null,
    );
  }
}
