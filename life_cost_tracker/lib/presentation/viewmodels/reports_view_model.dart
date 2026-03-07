// reports_view_model.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 报表 ViewModel
// Reports ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/usecases/generate_monthly_report_usecase.dart';
import '../../domain/usecases/generate_daily_cost_trend_usecase.dart';

/// Reports ViewModel - manages reports state
/// 报表 ViewModel - 管理报表的状态
class ReportsViewModel extends ChangeNotifier {
  /// Generate monthly report use case
  /// 生成月度报告用例
  final GenerateMonthlyReportUseCase _generateMonthlyReportUseCase;

  /// Generate daily cost trend use case
  /// 生成每日成本趋势用例
  final GenerateDailyCostTrendUseCase _generateDailyCostTrendUseCase;

  /// Selected month
  /// 选中的月份
  DateTime _selectedMonth = DateTime.now();

  /// Monthly report
  /// 月度报告
  MonthlyReport? _monthlyReport;

  /// Daily cost trend
  /// 每日成本趋势
  List<DailyCostDataPoint>? _dailyCostTrend;

  /// Loading state
  /// 加载状态
  bool _isLoading = false;

  /// Error message
  /// 错误信息
  String? _errorMessage;

  /// Constructor
  /// 构造函数
  ReportsViewModel({
    required GenerateMonthlyReportUseCase generateMonthlyReportUseCase,
    required GenerateDailyCostTrendUseCase generateDailyCostTrendUseCase,
  })  : _generateMonthlyReportUseCase = generateMonthlyReportUseCase,
        _generateDailyCostTrendUseCase = generateDailyCostTrendUseCase;

  /// Get selected month
  /// 获取选中的月份
  DateTime get selectedMonth => _selectedMonth;

  /// Get monthly report
  /// 获取月度报告
  MonthlyReport? get monthlyReport => _monthlyReport;

  /// Get daily cost trend
  /// 获取每日成本趋势
  List<DailyCostDataPoint>? get dailyCostTrend => _dailyCostTrend;

  /// Get loading state
  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// Get error message
  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// Set selected month
  /// 设置选中的月份
  void setSelectedMonth(DateTime month) {
    if (_selectedMonth.month != month.month ||
        _selectedMonth.year != month.year) {
      _selectedMonth = month;
      loadMonthlyReport();
      notifyListeners();
    }
  }

  /// Load monthly report
  /// 加载月度报告
  Future<void> loadMonthlyReport() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _monthlyReport = await _generateMonthlyReportUseCase(_selectedMonth);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load daily cost trend
  /// 加载每日成本趋势
  Future<void> loadDailyCostTrend() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dailyCostTrend = await _generateDailyCostTrendUseCase(DateTime.now());
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all reports
  /// 加载所有报表
  Future<void> loadAllReports() async {
    await Future.wait([
      loadMonthlyReport(),
      loadDailyCostTrend(),
    ]);
  }

  /// Go to previous month
  /// 前往上一个月
  void previousMonth() {
    final newMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    setSelectedMonth(newMonth);
  }

  /// Go to next month
  /// 前往下一个月
  void nextMonth() {
    final newMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    setSelectedMonth(newMonth);
  }
}
