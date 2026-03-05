// wishlist_item.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import 'package:uuid/uuid.dart';
import 'priority.dart';

class WishlistItem {
  final String id;
  final String name;
  final String? description;
  final DateTime? targetDate;
  final double totalCost;
  final int? estimatedUsageDays;
  final Priority priority;
  final String? photoUrl;
  final String? linkUrl;
  final bool isOwned;
  final int? actualUsageDays;

  double? get dailyCost {
    // If owned and we have actual usage days, calculate based on that
    if (isOwned && actualUsageDays != null && actualUsageDays! > 0) {
      return totalCost / actualUsageDays!;
    }

    // If target date is set, calculate daily savings needed
    if (targetDate != null && targetDate!.isAfter(DateTime.now())) {
      final days = targetDate!.difference(DateTime.now()).inDays;
      return totalCost / (days > 0 ? days : 1);
    }

    // Otherwise, calculate daily ownership cost based on estimated usage
    if (estimatedUsageDays != null && estimatedUsageDays! > 0) {
      return totalCost / estimatedUsageDays!;
    }

    return null;
  }

  WishlistItem({
    String? id,
    required this.name,
    this.description,
    this.targetDate,
    required this.totalCost,
    this.estimatedUsageDays,
    this.priority = Priority.medium,
    this.photoUrl,
    this.linkUrl,
    this.isOwned = false,
    this.actualUsageDays,
  }) : id = id ?? const Uuid().v4();

  WishlistItem copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? targetDate,
    double? totalCost,
    int? estimatedUsageDays,
    Priority? priority,
    String? photoUrl,
    String? linkUrl,
    bool? isOwned,
    int? actualUsageDays,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      totalCost: totalCost ?? this.totalCost,
      estimatedUsageDays: estimatedUsageDays ?? this.estimatedUsageDays,
      priority: priority ?? this.priority,
      photoUrl: photoUrl ?? this.photoUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      isOwned: isOwned ?? this.isOwned,
      actualUsageDays: actualUsageDays ?? this.actualUsageDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetDate': targetDate?.toIso8601String(),
      'totalCost': totalCost,
      'estimatedUsageDays': estimatedUsageDays,
      'priority': priority.name,
      'photoUrl': photoUrl,
      'linkUrl': linkUrl,
      'isOwned': isOwned,
      'actualUsageDays': actualUsageDays,
    };
  }

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
      totalCost: json['totalCost'] as double,
      estimatedUsageDays: json['estimatedUsageDays'] as int?,
      priority: Priority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => Priority.medium,
      ),
      photoUrl: json['photoUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      isOwned: json['isOwned'] as bool? ?? false,
      actualUsageDays: json['actualUsageDays'] as int?,
    );
  }
}
