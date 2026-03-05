// subscription.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import 'package:uuid/uuid.dart';
import 'billing_cycle.dart';
import 'subscription_category.dart';

class Subscription {
  final String id;
  final String name;
  final double cost;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final SubscriptionCategory category;
  final bool isFreeTrial;
  final DateTime? freeTrialEndDate;

  double get dailyCost {
    return cost / billingCycle.daysInCycle;
  }

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
