// date_utils.dart
// LifeCostTracker
// 安全日期计算工具

/// 安全地创建指定年月日的 DateTime，自动钳制日期到该月最大天数
/// 避免 DateTime(2025, 2, 31) → 3月3日 的问题
DateTime safeDate(int year, int month, int day) {
  // Dart 的 DateTime 会自动处理月份溢出（13月→下一年1月）
  // 但不会处理天数溢出（2月31→3月3），所以需要钳制 day
  final maxDay = DateTime(year, month + 1, 0).day; // 该月最后一天
  return DateTime(year, month, day.clamp(1, maxDay));
}

/// 在给定日期上加 N 个月，保持日期不溢出
DateTime addMonths(DateTime date, int months) {
  return safeDate(date.year, date.month + months, date.day);
}
