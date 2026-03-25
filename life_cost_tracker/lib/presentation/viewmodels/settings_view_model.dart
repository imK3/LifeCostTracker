// settings_view_model.dart
// LifeCostTracker
// 设置 ViewModel

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/display_cycle.dart';

/// ViewModel for settings
class SettingsViewModel extends ChangeNotifier {
  DisplayCycle _displayCycle = DisplayCycle.daily;
  String _currency = '¥';
  double _monthlyIncome = 0;

  static const _boxName = 'settings';

  DisplayCycle get displayCycle => _displayCycle;
  String get currency => _currency;
  double get monthlyIncome => _monthlyIncome;
  bool get hasIncome => _monthlyIncome > 0;

  SettingsViewModel() {
    _loadFromHive();
  }

  Future<void> _loadFromHive() async {
    final box = await Hive.openBox(_boxName);
    _monthlyIncome = box.get('monthlyIncome', defaultValue: 0.0) as double;
    _currency = box.get('currency', defaultValue: '¥') as String;
    final cycleIndex = box.get('displayCycleIndex', defaultValue: 0) as int;
    if (cycleIndex >= 0 && cycleIndex < DisplayCycle.values.length) {
      _displayCycle = DisplayCycle.values[cycleIndex];
    }
    notifyListeners();
  }

  void setDisplayCycle(DisplayCycle cycle) {
    _displayCycle = cycle;
    _save('displayCycleIndex', cycle.index);
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    _save('currency', currency);
    notifyListeners();
  }

  void setMonthlyIncome(double income) {
    _monthlyIncome = income;
    _save('monthlyIncome', income);
    notifyListeners();
  }

  Future<void> _save(String key, dynamic value) async {
    final box = await Hive.openBox(_boxName);
    await box.put(key, value);
  }

  /// 当月实际天数
  static int get _daysInCurrentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  /// dailyCost → 月度成本（用当月实际天数）
  static double dailyToMonthly(double dailyCost) =>
      dailyCost * _daysInCurrentMonth;

  /// 睡后成本占收入比例（月度）
  double costRatio(double totalDailyCost) {
    if (_monthlyIncome <= 0) return -1;
    return dailyToMonthly(totalDailyCost) / _monthlyIncome;
  }

  /// 幸福感等级
  static HappinessLevel happinessFromRatio(double ratio) {
    if (ratio < 0) return HappinessLevel.unknown;
    if (ratio <= 0.40) return HappinessLevel.excellent;
    if (ratio <= 0.55) return HappinessLevel.good;
    if (ratio <= 0.70) return HappinessLevel.normal;
    if (ratio <= 0.85) return HappinessLevel.tight;
    return HappinessLevel.stressed;
  }

  /// 综合幸福感评分（0-100）
  /// 基于总占比，非线性映射：
  /// 0-30% → 95-100, 30-50% → 80-95, 50-65% → 60-80,
  /// 65-80% → 35-60, 80-100% → 10-35, >100% → 0-10
  static int happinessScore(double ratio) {
    if (ratio < 0) return -1;
    if (ratio <= 0.30) return (100 - (ratio / 0.30 * 5)).round();
    if (ratio <= 0.50) return (95 - ((ratio - 0.30) / 0.20 * 15)).round();
    if (ratio <= 0.65) return (80 - ((ratio - 0.50) / 0.15 * 20)).round();
    if (ratio <= 0.80) return (60 - ((ratio - 0.65) / 0.15 * 25)).round();
    if (ratio <= 1.00) return (35 - ((ratio - 0.80) / 0.20 * 25)).round();
    return (10 - ((ratio - 1.0) * 20)).round().clamp(0, 10);
  }

  /// 评分对应的等级描述
  static String scoreLabel(int score) {
    if (score < 0) return '未知';
    if (score >= 90) return '优秀';
    if (score >= 75) return '良好';
    if (score >= 60) return '一般';
    if (score >= 40) return '偏紧';
    return '危险';
  }

  /// 评分对应的颜色
  static Color scoreColor(int score) {
    if (score >= 90) return const Color(0xFF4CAF50);
    if (score >= 75) return const Color(0xFF8BC34A);
    if (score >= 60) return const Color(0xFFFFC107);
    if (score >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}

enum HappinessLevel {
  unknown,
  excellent,
  good,
  normal,
  tight,
  stressed;

  String get emoji {
    switch (this) {
      case HappinessLevel.unknown: return '🤔';
      case HappinessLevel.excellent: return '😎';
      case HappinessLevel.good: return '😊';
      case HappinessLevel.normal: return '😐';
      case HappinessLevel.tight: return '😰';
      case HappinessLevel.stressed: return '😵';
    }
  }

  String get label {
    switch (this) {
      case HappinessLevel.unknown: return '设置收入查看';
      case HappinessLevel.excellent: return '财务自由度高';
      case HappinessLevel.good: return '生活比较从容';
      case HappinessLevel.normal: return '收支基本平衡';
      case HappinessLevel.tight: return '有些紧张';
      case HappinessLevel.stressed: return '压力很大';
    }
  }

  Color get color {
    switch (this) {
      case HappinessLevel.unknown: return const Color(0xFF9E9E9E);
      case HappinessLevel.excellent: return const Color(0xFF4CAF50);
      case HappinessLevel.good: return const Color(0xFF8BC34A);
      case HappinessLevel.normal: return const Color(0xFFFFC107);
      case HappinessLevel.tight: return const Color(0xFFFF9800);
      case HappinessLevel.stressed: return const Color(0xFFF44336);
    }
  }
}
