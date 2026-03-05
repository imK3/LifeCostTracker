// wishlist_item_test.dart
// LifeCostTracker Tests
// Created by LifeCostTracker Team

import 'package:flutter_test/flutter_test.dart';
import 'package:life_cost_tracker/domain/entities/wishlist_item.dart';
import 'package:life_cost_tracker/domain/entities/priority.dart';

void main() {
  group('WishlistItem Entity Tests (愿望清单项实体测试)', () {
    test('should create a WishlistItem with default values (应该使用默认值创建愿望清单项)', () {
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 1000.0,
      );

      // Verify that all properties have correct default values
      // 验证所有属性是否具有正确的默认值
      expect(item.id, isNotNull);
      expect(item.name, 'Test Item');
      expect(item.totalCost, 1000.0);
      expect(item.description, isNull);
      expect(item.targetDate, isNull);
      expect(item.estimatedUsageDays, isNull);
      expect(item.priority, Priority.medium);
      expect(item.photoUrl, isNull);
      expect(item.linkUrl, isNull);
      expect(item.isOwned, false);
      expect(item.actualUsageDays, isNull);
    });

    test('should calculate dailyCost when owned and has actualUsageDays (当已拥有且有实际使用天数时，应该计算每日成本)', () {
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 365.0,
        isOwned: true,
        actualUsageDays: 365,
      );

      // 365 amount / 365 days = 1.0 daily cost
      // 365 总金额 / 365 天 = 1.0 每日成本
      expect(item.dailyCost, 1.0);
    });

    test('should calculate dailyCost when has targetDate (当有目标日期时，应该计算每日成本)', () {
      final targetDate = DateTime.now().add(const Duration(days: 100));
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 100.0,
        targetDate: targetDate,
      );

      // 100 amount / 100 days = 1.0 daily cost (approximately)
      // 100 总金额 / 100 天 ≈ 1.0 每日成本
      expect(item.dailyCost, closeTo(1.0, 0.1));
    });

    test('should calculate dailyCost when has estimatedUsageDays (当有预计使用天数时，应该计算每日成本)', () {
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 1000.0,
        estimatedUsageDays: 100,
      );

      // 1000 amount / 100 days = 10.0 daily cost
      // 1000 总金额 / 100 天 = 10.0 每日成本
      expect(item.dailyCost, 10.0);
    });

    test('should return null for dailyCost when no usage info (当没有使用信息时，每日成本应返回 null)', () {
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 1000.0,
      );

      expect(item.dailyCost, isNull);
    });

    test('should create a copy with updated values using copyWith (应该使用 copyWith 创建包含更新值的副本)', () {
      final original = WishlistItem(
        name: 'Original Item',
        totalCost: 1000.0,
        priority: Priority.low,
      );

      final updated = original.copyWith(
        name: 'Updated Item',
        totalCost: 2000.0,
        priority: Priority.high,
      );

      // Verify that specified values are updated and others remain the same
      // 验证指定的值已更新，其他值保持不变
      expect(updated.id, original.id);
      expect(updated.name, 'Updated Item');
      expect(updated.totalCost, 2000.0);
      expect(updated.priority, Priority.high);
    });

    test('should convert to and from JSON correctly (应该正确地与 JSON 进行相互转换)', () {
      final item = WishlistItem(
        name: 'Test Item',
        totalCost: 1000.0,
        description: 'Test description',
        estimatedUsageDays: 100,
        priority: Priority.high,
        isOwned: false,
      );

      final json = item.toJson();
      final fromJson = WishlistItem.fromJson(json);

      // Verify that object created from JSON matches the original
      // 验证从 JSON 创建的对象与原始对象一致
      expect(fromJson.id, item.id);
      expect(fromJson.name, item.name);
      expect(fromJson.description, item.description);
      expect(fromJson.totalCost, item.totalCost);
      expect(fromJson.estimatedUsageDays, item.estimatedUsageDays);
      expect(fromJson.priority, item.priority);
      expect(fromJson.isOwned, item.isOwned);
    });
  });
}
