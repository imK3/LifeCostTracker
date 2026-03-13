// cost_category.dart
// LifeCostTracker
// 成本分类（大类 + 子分类）

import 'package:flutter/material.dart';

/// Cost category group - top-level grouping
/// 成本大类
enum CostCategoryGroup {
  housing,
  transport,
  living,
  communication,
  digitalSubscription,
  healthCare,
  education,
  other;

  String get displayName {
    switch (this) {
      case CostCategoryGroup.housing:
        return '居住';
      case CostCategoryGroup.transport:
        return '交通';
      case CostCategoryGroup.living:
        return '生活';
      case CostCategoryGroup.communication:
        return '通信';
      case CostCategoryGroup.digitalSubscription:
        return '数字订阅';
      case CostCategoryGroup.healthCare:
        return '医疗健康';
      case CostCategoryGroup.education:
        return '教育';
      case CostCategoryGroup.other:
        return '其他';
    }
  }

  IconData get icon {
    switch (this) {
      case CostCategoryGroup.housing:
        return Icons.home;
      case CostCategoryGroup.transport:
        return Icons.directions_car;
      case CostCategoryGroup.living:
        return Icons.restaurant;
      case CostCategoryGroup.communication:
        return Icons.phone_android;
      case CostCategoryGroup.digitalSubscription:
        return Icons.laptop;
      case CostCategoryGroup.healthCare:
        return Icons.local_hospital;
      case CostCategoryGroup.education:
        return Icons.school;
      case CostCategoryGroup.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case CostCategoryGroup.housing:
        return const Color(0xFFE57373); // red
      case CostCategoryGroup.transport:
        return const Color(0xFF64B5F6); // blue
      case CostCategoryGroup.living:
        return const Color(0xFFFFB74D); // orange
      case CostCategoryGroup.communication:
        return const Color(0xFF4DB6AC); // teal
      case CostCategoryGroup.digitalSubscription:
        return const Color(0xFF9575CD); // purple
      case CostCategoryGroup.healthCare:
        return const Color(0xFF81C784); // green
      case CostCategoryGroup.education:
        return const Color(0xFFFFD54F); // amber
      case CostCategoryGroup.other:
        return const Color(0xFF90A4AE); // grey
    }
  }
}

/// Cost category enum - specific expense types
/// 成本子分类
enum CostCategory {
  // === 居住 ===
  rent,
  mortgage,
  utilities,
  propertyFee,
  parking,

  // === 交通 ===
  carLoan,
  carInsurance,
  commute,
  fuel,

  // === 生活 ===
  groceries,
  dailySupplies,

  // === 通信 ===
  phoneBill,
  internet,

  // === 数字订阅 ===
  streaming,
  productivity,
  cloudServices,
  gaming,

  // === 医疗健康 ===
  insurance,
  fitness,
  medical,

  // === 教育 ===
  course,
  bookSubscription,

  // === 其他 ===
  pet,
  socialGift,
  other;

  /// 所属大类
  CostCategoryGroup get group {
    switch (this) {
      case CostCategory.rent:
      case CostCategory.mortgage:
      case CostCategory.utilities:
      case CostCategory.propertyFee:
      case CostCategory.parking:
        return CostCategoryGroup.housing;
      case CostCategory.carLoan:
      case CostCategory.carInsurance:
      case CostCategory.commute:
      case CostCategory.fuel:
        return CostCategoryGroup.transport;
      case CostCategory.groceries:
      case CostCategory.dailySupplies:
        return CostCategoryGroup.living;
      case CostCategory.phoneBill:
      case CostCategory.internet:
        return CostCategoryGroup.communication;
      case CostCategory.streaming:
      case CostCategory.productivity:
      case CostCategory.cloudServices:
      case CostCategory.gaming:
        return CostCategoryGroup.digitalSubscription;
      case CostCategory.insurance:
      case CostCategory.fitness:
      case CostCategory.medical:
        return CostCategoryGroup.healthCare;
      case CostCategory.course:
      case CostCategory.bookSubscription:
        return CostCategoryGroup.education;
      case CostCategory.pet:
      case CostCategory.socialGift:
      case CostCategory.other:
        return CostCategoryGroup.other;
    }
  }

  String get displayName {
    switch (this) {
      case CostCategory.rent:
        return '房租';
      case CostCategory.mortgage:
        return '房贷';
      case CostCategory.utilities:
        return '水电煤';
      case CostCategory.propertyFee:
        return '物业费';
      case CostCategory.parking:
        return '停车费';
      case CostCategory.carLoan:
        return '车贷';
      case CostCategory.carInsurance:
        return '车险';
      case CostCategory.commute:
        return '通勤月卡';
      case CostCategory.fuel:
        return '加油';
      case CostCategory.groceries:
        return '日常伙食';
      case CostCategory.dailySupplies:
        return '日用品';
      case CostCategory.phoneBill:
        return '话费';
      case CostCategory.internet:
        return '宽带';
      case CostCategory.streaming:
        return '流媒体';
      case CostCategory.productivity:
        return '生产力工具';
      case CostCategory.cloudServices:
        return '云服务';
      case CostCategory.gaming:
        return '游戏会员';
      case CostCategory.insurance:
        return '保险';
      case CostCategory.fitness:
        return '健身';
      case CostCategory.medical:
        return '医疗体检';
      case CostCategory.course:
        return '培训网课';
      case CostCategory.bookSubscription:
        return '书籍订阅';
      case CostCategory.pet:
        return '宠物';
      case CostCategory.socialGift:
        return '人情往来';
      case CostCategory.other:
        return '其他';
    }
  }

  IconData get icon {
    switch (this) {
      case CostCategory.rent:
        return Icons.home;
      case CostCategory.mortgage:
        return Icons.account_balance;
      case CostCategory.utilities:
        return Icons.bolt;
      case CostCategory.propertyFee:
        return Icons.apartment;
      case CostCategory.parking:
        return Icons.local_parking;
      case CostCategory.carLoan:
        return Icons.directions_car;
      case CostCategory.carInsurance:
        return Icons.shield;
      case CostCategory.commute:
        return Icons.directions_bus;
      case CostCategory.fuel:
        return Icons.local_gas_station;
      case CostCategory.groceries:
        return Icons.restaurant;
      case CostCategory.dailySupplies:
        return Icons.shopping_basket;
      case CostCategory.phoneBill:
        return Icons.phone_android;
      case CostCategory.internet:
        return Icons.wifi;
      case CostCategory.streaming:
        return Icons.tv;
      case CostCategory.productivity:
        return Icons.description;
      case CostCategory.cloudServices:
        return Icons.cloud;
      case CostCategory.gaming:
        return Icons.gamepad;
      case CostCategory.insurance:
        return Icons.health_and_safety;
      case CostCategory.fitness:
        return Icons.fitness_center;
      case CostCategory.medical:
        return Icons.local_hospital;
      case CostCategory.course:
        return Icons.school;
      case CostCategory.bookSubscription:
        return Icons.menu_book;
      case CostCategory.pet:
        return Icons.pets;
      case CostCategory.socialGift:
        return Icons.card_giftcard;
      case CostCategory.other:
        return Icons.more_horiz;
    }
  }
}
