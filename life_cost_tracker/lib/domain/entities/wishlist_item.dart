// wishlist_item.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 愿望清单项实体
// Wishlist item entity

import 'package:uuid/uuid.dart';
import 'priority.dart';

/// Wishlist item entity - represents an item on the wishlist
/// 愿望清单项实体 - 表示愿望清单上的一个物品
class WishlistItem {
  /// Unique identifier for the wishlist item
  /// 愿望清单项的唯一标识符
  final String id;

  /// Name of the wishlist item
  /// 愿望清单项的名称
  final String name;

  /// Optional description of the wishlist item
  /// 愿望清单项的可选描述
  final String? description;

  /// Target purchase date for the wishlist item
  /// 愿望清单项的目标购买日期
  final DateTime? targetDate;

  /// Total cost of the wishlist item
  /// 愿望清单项的总费用
  final double totalCost;

  /// Estimated usage days for daily cost calculation
  /// 用于每日成本计算的预计使用天数
  final int? estimatedUsageDays;

  /// Priority of the wishlist item
  /// 愿望清单项的优先级
  final Priority priority;

  /// Optional URL to photo of the item
  /// 物品照片的可选 URL
  final String? photoUrl;

  /// Optional URL to link of the item
  /// 物品链接的可选 URL
  final String? linkUrl;

  /// Whether the item is already owned
  /// 物品是否已拥有
  final bool isOwned;

  /// Actual usage days (only for owned items)
  /// 实际使用天数（仅适用于已拥有的物品）
  final int? actualUsageDays;

  /// Calculate daily cost based on various factors
  /// 根据各种因素计算每日成本
  double? get dailyCost {
    // If owned and we have actual usage days, calculate based on that
    // 如果已拥有且有实际使用天数，基于此计算
    if (isOwned && actualUsageDays != null && actualUsageDays! > 0) {
      return totalCost / actualUsageDays!;
    }

    // If target date is set, calculate daily savings needed
    // 如果设置了目标日期，计算所需的每日储蓄
    if (targetDate != null && targetDate!.isAfter(DateTime.now())) {
      final days = targetDate!.difference(DateTime.now()).inDays;
      return totalCost / (days > 0 ? days : 1);
    }

    // Otherwise, calculate daily ownership cost based on estimated usage
    // 否则，基于预计使用天数计算每日拥有成本
    if (estimatedUsageDays != null && estimatedUsageDays! > 0) {
      return totalCost / estimatedUsageDays!;
    }

    return null;
  }

  /// Create a new WishlistItem
  /// 创建一个新的愿望清单项
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

  /// Create a copy of the WishlistItem with optional updated values
  /// 创建一个愿望清单项的副本，并可选择更新值
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

  /// Convert WishlistItem to JSON
  /// 将愿望清单项转换为 JSON
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

  /// Create WishlistItem from JSON
  /// 从 JSON 创建愿望清单项
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
