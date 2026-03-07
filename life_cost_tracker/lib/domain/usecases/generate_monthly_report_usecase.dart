// generate_monthly_report_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 生成月度报告用例
// Generate monthly report use case

import '../entities/expense.dart';
import '../entities/subscription.dart';
import '../repositories/expense_repository.dart';
import '../repositories/subscription_repository.dart';
import 'base_usecase.dart';

/// Monthly report data
/// 月度报告数据
class MonthlyReport {
  /// Month of the report
  /// 报告的月份
  final int month;

  /// Year of the report
  /// 报告的年份
  final int year;

  /// Total expenses
  /// 总支出
  final double totalExpenses;

  /// Total subscriptions
  /// 总订阅
  final double totalSubscriptions;

  /// Total spending
  /// 总花费
  double get totalSpending => totalExpenses + totalSubscriptions;

  /// Number of expenses
  /// 支出数量
  final int expenseCount;

  /// Number of active subscriptions
  /// 活跃订阅数量
  final int subscriptionCount;

  /// Average daily cost
  /// 平均每日成本
  double? get averageDailyCost {
    final days = DateTime(year, month + 1, 0)
        .difference(DateTime(year, month, 1))
        .inDays;
    if (days <= 0) return null;
    return totalSpending / days;
  }

  MonthlyReport({
    required this.month,
    required this.year,
    required this.totalExpenses,
    required this.totalSubscriptions,
    required this.expenseCount,
    required this.subscriptionCount,
  });
}

/// Generate monthly report use case
/// 生成月度报告用例
class GenerateMonthlyReportUseCase
    implements BaseUseCase<MonthlyReport, DateTime> {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Constructor
  /// 构造函数
  GenerateMonthlyReportUseCase({
    required this.expenseRepository,
    required this.subscriptionRepository,
  });

  /// Execute * use case to generate monthly report
  /// 执行用例以生成月度报告
  @override
  Future<MonthlyReport> call(DateTime date) async {
    final month = date.month;
    final year = date.year;

    // Get all expenses and filter by month
    // 获取所有支出并按月过滤
    final expenses = await expenseRepository.getExpenses();
    final monthExpenses = expenses
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();

    // Get all subscriptions
    // 获取所有订阅
    final subscriptions = await subscriptionRepository.getSubscriptions();

    // Calculate totals
    // 计算总计
    double totalExpenses = 0;
    for (final expense in monthExpenses) {
      totalExpenses += expense.amount;
    }

    double totalSubscriptions = 0;
    for (final subscription in subscriptions) {
      totalSubscriptions += subscription.cost;
    }

    return MonthlyReport(
      month: month,
      year: year,
      totalExpenses: totalExpenses,
      totalSubscriptions: totalSubscriptions,
      expenseCount: monthExpenses.length,
      subscriptionCount: subscriptions.length,
    );
  }
}
