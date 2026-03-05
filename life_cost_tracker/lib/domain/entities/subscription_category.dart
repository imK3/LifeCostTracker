// subscription_category.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 订阅分类
// Subscription category

/// Subscription category enum
/// 订阅分类枚举
enum SubscriptionCategory {
  /// Streaming services
  /// 流媒体
  streaming,

  /// Productivity tools
  /// 生产力
  productivity,

  /// Food delivery services
  /// 外卖
  foodDelivery,

  /// Fitness services
  /// 健身
  fitness,

  /// News services
  /// 新闻
  news,

  /// Cloud services/tools
  /// 云服务/工具
  cloudServices,

  /// Digital peripherals
  /// 数码外设
  digitalPeripherals,

  /// Gaming services
  /// 游戏娱乐
  gaming,

  /// Music streaming services
  /// 音乐串流
  musicStreaming,

  /// Other categories
  /// 其他
  other;

  /// Display name for the subscription category in Chinese
  /// 订阅分类的中文显示名称
  String get displayName {
    switch (this) {
      case SubscriptionCategory.streaming:
        return '流媒体';
      case SubscriptionCategory.productivity:
        return '生产力';
      case SubscriptionCategory.foodDelivery:
        return '外卖';
      case SubscriptionCategory.fitness:
        return '健身';
      case SubscriptionCategory.news:
        return '新闻';
      case SubscriptionCategory.cloudServices:
        return '云服务/工具';
      case SubscriptionCategory.digitalPeripherals:
        return '数码外设';
      case SubscriptionCategory.gaming:
        return '游戏娱乐';
      case SubscriptionCategory.musicStreaming:
        return '音乐串流';
      case SubscriptionCategory.other:
        return '其他';
    }
  }

  /// System icon name for the subscription category
  /// 订阅分类的系统图标名称
  String get systemIconName {
    switch (this) {
      case SubscriptionCategory.streaming:
        return 'tv';
      case SubscriptionCategory.productivity:
        return 'description';
      case SubscriptionCategory.foodDelivery:
        return 'restaurant';
      case SubscriptionCategory.fitness:
        return 'fitness_center';
      case SubscriptionCategory.news:
        return 'article';
      case SubscriptionCategory.cloudServices:
        return 'cloud';
      case SubscriptionCategory.digitalPeripherals:
        return 'keyboard';
      case SubscriptionCategory.gaming:
        return 'gamepad';
      case SubscriptionCategory.musicStreaming:
        return 'music_note';
      case SubscriptionCategory.other:
        return 'more_horiz';
    }
  }
}
