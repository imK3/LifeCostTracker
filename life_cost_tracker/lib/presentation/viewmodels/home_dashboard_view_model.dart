// home_dashboard_view_model.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 首页仪表板 ViewModel
// Home Dashboard ViewModel

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/credit_account_repository.dart';
import '../../domain/usecases/calculate_average_daily_cost_usecase.dart';
import '../../domain/usecases/get_upcoming_obligations_usecase.dart';
import '../../domain/usecases/calculate_credit_utilization_usecase.dart';
import '../../domain/usecases/calculate_daily_cost_breakdown_usecase.dart';
import '../../domain/usecases/base_usecase.dart';

/// Home Dashboard ViewModel - manages home dashboard state
/// 首页仪表板 ViewModel - 管理首页仪表板的状态
class HomeDashboardViewModel extends ChangeNotifier {
  /// Expense repository
  /// 支出仓库
  final ExpenseRepository _expenseRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository _subscriptionRepository;

  /// Credit account repository
  /// 信用账户仓库
  final CreditAccountRepository _creditAccountRepository;

  /// Calculate average daily cost use case
  /// 计算平均每日成本用例
  final CalculateAverageDailyCostUseCase _calculateAverageDailyCostUseCase;

  /// Get upcoming obligations use case
  /// 获取即将到期的义务用例
  final GetUpcomingObligationsUseCase _getUpcomingObligationsUseCase;

  /// Calculate credit utilization use case
  /// 计算信用利用率用例
  final CalculateCreditUtilizationUseCase _calculateCreditUtilizationUseCase;

  /// Calculate daily cost breakdown use case
  /// 计算每日成本明细用例
  final CalculateDailyCostBreakdownUseCase _calculateDailyCostBreakdownUseCase;

  /// Monthly summary (to be implemented)
  /// 月度汇总（待实现）
  String? _monthlySummary;

  /// Upcoming obligations
  /// 即将到期的义务
  List<Obligation>? _upcomingObligations;

  /// Credit health snapshot
  /// 信用健康快照
  double? _creditHealthSnapshot;

  /// Average daily cost
  /// 平均每日成本
  double? _averageDailyCost;

  /// Daily cost breakdown
  /// 每日成本明细
  DailyCostBreakdown? _dailyCostBreakdown;

  /// Loading state
  /// 加载状态
  bool _isLoading = false;

  /// Error message
  /// 错误信息
  String? _errorMessage;

  /// Constructor
  /// 构造函数
  HomeDashboardViewModel({
    required ExpenseRepository expenseRepository,
    required SubscriptionRepository subscriptionRepository,
    required CreditAccountRepository creditAccountRepository,
    required CalculateAverageDailyCostUseCase calculateAverageDailyCostUseCase,
    required GetUpcomingObligationsUseCase getUpcomingObligationsUseCase,
    required CalculateCreditUtilizationUseCase calculateCreditUtilizationUseCase,
    required CalculateDailyCostBreakdownUseCase calculateDailyCostBreakdownUseCase,
  })  : _expenseRepository = expenseRepository,
        _subscriptionRepository = subscriptionRepository,
        _creditAccountRepository = creditAccountRepository,
        _calculateAverageDailyCostUseCase = calculateAverageDailyCostUseCase,
        _getUpcomingObligationsUseCase = getUpcomingObligationsUseCase,
        _calculateCreditUtilizationUseCase = calculateCreditUtilizationUseCase,
        _calculateDailyCostBreakdownUseCase = calculateDailyCostBreakdownUseCase;

  /// Get monthly summary
  /// 获取月度汇总
  String? get monthlySummary => _monthlySummary;

  /// Get upcoming obligations
  /// 获取即将到期的义务
  List<Obligation>? get upcomingObligations => _upcomingObligations;

  /// Get credit health snapshot
  /// 获取信用健康快照
  double? get creditHealthSnapshot => _creditHealthSnapshot;

  /// Get average daily cost
  /// 获取平均每日成本
  double? get averageDailyCost => _averageDailyCost;

  /// Get daily cost breakdown
  /// 获取每日成本明细
  DailyCostBreakdown? get dailyCostBreakdown => _dailyCostBreakdown;

  /// Get loading state
  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// Get error message
  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// Load all dashboard data
  /// 加载所有仪表板数据
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load data in parallel
      // 并行加载数据
      await Future.wait([
        _loadAverageDailyCost(),
        _loadUpcomingObligations(),
        _loadCreditHealthSnapshot(),
        _loadDailyCostBreakdown(),
      ]);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load average daily cost
  /// 加载平均每日成本
  Future<void> _loadAverageDailyCost() async {
    _averageDailyCost = await _calculateAverageDailyCostUseCase(NoParams());
  }

  /// Load upcoming obligations
  /// 加载即将到期的义务
  Future<void> _loadUpcomingObligations() async {
    _upcomingObligations = await _getUpcomingObligationsUseCase(NoParams());
  }

  /// Load credit health snapshot
  /// 加载信用健康快照
  Future<void> _loadCreditHealthSnapshot() async {
    _creditHealthSnapshot = await _calculateCreditUtilizationUseCase(NoParams());
  }

  /// Load daily cost breakdown
  /// 加载每日成本明细
  Future<void> _loadDailyCostBreakdown() async {
    _dailyCostBreakdown = await _calculateDailyCostBreakdownUseCase(NoParams());
  }
}
