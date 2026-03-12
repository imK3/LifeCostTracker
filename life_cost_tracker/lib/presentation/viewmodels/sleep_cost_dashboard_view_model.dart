// sleep_cost_dashboard_view_model.dart
// LifeCostTracker
// 睡后成本 Dashboard ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/sleep_cost_summary.dart';
import '../../domain/entities/display_cycle.dart';
import '../../domain/usecases/base_usecase.dart';
import '../../domain/usecases/calculate_sleep_cost_usecase.dart';

/// ViewModel for the sleep cost dashboard
class SleepCostDashboardViewModel extends ChangeNotifier {
  final CalculateSleepCostUseCase _calculateSleepCostUseCase;

  SleepCostDashboardViewModel({
    required CalculateSleepCostUseCase calculateSleepCostUseCase,
  }) : _calculateSleepCostUseCase = calculateSleepCostUseCase;

  // State
  SleepCostSummary _summary = SleepCostSummary.empty;
  DisplayCycle _displayCycle = DisplayCycle.daily;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  SleepCostSummary get summary => _summary;
  DisplayCycle get displayCycle => _displayCycle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Burn rate display cost
  double get displayCost => _summary.displayCost(_displayCycle);

  double get fixedLivingDisplayCost =>
      _summary.fixedLivingDisplayCost(_displayCycle);

  double get subscriptionDisplayCost =>
      _summary.subscriptionDisplayCost(_displayCycle);

  double get installmentDisplayCost =>
      _summary.installmentDisplayCost(_displayCycle);

  /// Load dashboard data
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
  void setDisplayCycle(DisplayCycle cycle) {
    _displayCycle = cycle;
    notifyListeners();
  }
}
