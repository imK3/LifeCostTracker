// subscription_category.dart
// LifeCostTracker
// Created by LifeCostTracker Team

enum SubscriptionCategory {
  streaming,
  productivity,
  foodDelivery,
  fitness,
  news,
  cloudServices,
  digitalPeripherals,
  gaming,
  musicStreaming,
  other;

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
