// sleep_cost_dashboard_view_model.dart
// LifeCostTracker
// 睡后成本 Dashboard ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/sleep_cost_summary.dart';
import '../../domain/entities/display_cycle.dart';
import '../../domain/usecases/base_usecase.dart';
import '../../domain/usecases/calculate_sleep_cost_usecase.dart';

/// ViewModel for the sleep cost dashboard
/// 睡后成本 Dashboard 的 ViewModel
class SleepCostDashboardViewModel extends ChangeNotifier {
  final CalculateSleepCostUseCase _calculateSleepCostUseCase;

  SleepCostDashboardViewModel({
    required CalculateSleepCostUseCase calculateSleepCostUseCase,
  }) : _calculateSleepCostUseCase = calculateSleepCostUseCase;

  // State
  SleepCostSummary _summary = SleepCostSummary.empty;
  DisplayCycle _displayCycle = DisplayCycle.daily;
  DisplayCycle _paymentCycle = DisplayCycle.monthly;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  SleepCostSummary get summary => _summary;
  DisplayCycle get displayCycle => _displayCycle;
  DisplayCycle get paymentCycle => _paymentCycle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Main display cost based on selected cycle
  /// 基于选择周期的主展示成本
  double get displayCost => _summary.displayCost(_displayCycle);

  /// Fixed living display cost
  double get fixedLivingDisplayCost =>
      _summary.fixedLivingDisplayCost(_displayCycle);

  /// Subscription display cost
  double get subscriptionDisplayCost =>
      _summary.subscriptionDisplayCost(_displayCycle);

  /// Installment display cost
  double get installmentDisplayCost =>
      _summary.installmentDisplayCost(_displayCycle);

  /// Load dashboard data
  /// 加载 Dashboard 数据
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _calculateSleepCostUseCase.call(NoParams());
    } catch (e) {
      _errorMessage = '加载数据失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change the display cycle (burn rate)
  /// 切换展示周期（燃烧率）
  void setDisplayCycle(DisplayCycle cycle) {
    _displayCycle = cycle;
    notifyListeners();
  }

  /// Change the payment tracking cycle
  /// 切换缴费追踪周期
  void setPaymentCycle(DisplayCycle cycle) {
    _paymentCycle = cycle;
    notifyListeners();
  }
}
