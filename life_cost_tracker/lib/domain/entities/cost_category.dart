// cost_category.dart
// LifeCostTracker
// 周期性成本分类（统一固定生活成本和订阅费用）
// Cost category (unified for fixed living costs and subscriptions)

import 'package:flutter/material.dart';

/// Cost category enum - covers all types of recurring costs
/// 成本分类枚举 - 涵盖所有类型的周期性成本
enum CostCategory {
  // === 固定生活成本 ===
  /// Rent
  /// 房租
  rent,

  /// Utilities (water, electricity, gas)
  /// 水电煤
  utilities,

  /// Parking
  /// 停车费
  parking,

  /// Property management fee
  /// 物业费
  propertyFee,

  /// Daily meals / groceries
  /// 日常伙食
  groceries,

  /// Transportation / commute
  /// 交通通勤
  transport,

  /// Insurance
  /// 保险
  insurance,

  // === 订阅费用 ===
  /// Streaming services (video, music)
  /// 流媒体（视频、音乐）
  streaming,

  /// Productivity tools
  /// 生产力工具
  productivity,

  /// Cloud services
  /// 云服务
  cloudServices,

  /// Phone bill
  /// 话费
  phoneBill,

  /// Gaming
  /// 游戏娱乐
  gaming,

  /// Fitness
  /// 健身
  fitness,

  /// Other
  /// 其他
  other;

  /// Display name in Chinese
  /// 中文显示名称
  String get displayName {
    switch (this) {
      case CostCategory.rent:
        return '房租';
      case CostCategory.utilities:
        return '水电煤';
      case CostCategory.parking:
        return '停车费';
      case CostCategory.propertyFee:
        return '物业费';
      case CostCategory.groceries:
        return '日常伙食';
      case CostCategory.transport:
        return '交通通勤';
      case CostCategory.insurance:
        return '保险';
      case CostCategory.streaming:
        return '流媒体';
      case CostCategory.productivity:
        return '生产力工具';
      case CostCategory.cloudServices:
        return '云服务';
      case CostCategory.phoneBill:
        return '话费';
      case CostCategory.gaming:
        return '游戏娱乐';
      case CostCategory.fitness:
        return '健身';
      case CostCategory.other:
        return '其他';
    }
  }

  /// Whether this category belongs to fixed living costs
  /// 是否属于固定生活成本
  bool get isFixedLiving {
    switch (this) {
      case CostCategory.rent:
      case CostCategory.utilities:
      case CostCategory.parking:
      case CostCategory.propertyFee:
      case CostCategory.groceries:
      case CostCategory.transport:
      case CostCategory.insurance:
        return true;
      default:
        return false;
    }
  }

  /// Whether this category belongs to subscriptions
  /// 是否属于订阅费用
  bool get isSubscription => !isFixedLiving;

  /// Icon data for this category
  /// 分类图标
  IconData get icon {
    switch (this) {
      case CostCategory.rent:
        return Icons.home;
      case CostCategory.utilities:
        return Icons.bolt;
      case CostCategory.parking:
        return Icons.local_parking;
      case CostCategory.propertyFee:
        return Icons.apartment;
      case CostCategory.groceries:
        return Icons.restaurant;
      case CostCategory.transport:
        return Icons.directions_bus;
      case CostCategory.insurance:
        return Icons.shield;
      case CostCategory.streaming:
        return Icons.tv;
      case CostCategory.productivity:
        return Icons.description;
      case CostCategory.cloudServices:
        return Icons.cloud;
      case CostCategory.phoneBill:
        return Icons.phone_android;
      case CostCategory.gaming:
        return Icons.gamepad;
      case CostCategory.fitness:
        return Icons.fitness_center;
      case CostCategory.other:
        return Icons.more_horiz;
    }
  }
}
