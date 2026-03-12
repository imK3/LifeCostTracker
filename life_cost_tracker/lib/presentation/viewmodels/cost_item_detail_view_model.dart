// cost_item_detail_view_model.dart
// LifeCostTracker
// 成本项详情 ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';
import '../../domain/usecases/manage_recurring_cost_usecase.dart';
import '../../domain/usecases/manage_installment_plan_usecase.dart';

/// Type of cost item being viewed
enum CostItemType { recurring, installment }

/// ViewModel for cost item detail/edit
class CostItemDetailViewModel extends ChangeNotifier {
  final UpdateRecurringCostUseCase _updateRecurringCostUseCase;
  final DeleteRecurringCostUseCase _deleteRecurringCostUseCase;
  final UpdateInstallmentPlanUseCase _updateInstallmentPlanUseCase;
  final DeleteInstallmentPlanUseCase _deleteInstallmentPlanUseCase;

  CostItemDetailViewModel({
    required UpdateRecurringCostUseCase updateRecurringCostUseCase,
    required DeleteRecurringCostUseCase deleteRecurringCostUseCase,
    required UpdateInstallmentPlanUseCase updateInstallmentPlanUseCase,
    required DeleteInstallmentPlanUseCase deleteInstallmentPlanUseCase,
  })  : _updateRecurringCostUseCase = updateRecurringCostUseCase,
        _deleteRecurringCostUseCase = deleteRecurringCostUseCase,
        _updateInstallmentPlanUseCase = updateInstallmentPlanUseCase,
        _deleteInstallmentPlanUseCase = deleteInstallmentPlanUseCase;

  // State
  CostItemType? _itemType;
  RecurringCost? _recurringCost;
  InstallmentPlan? _installmentPlan;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  CostItemType? get itemType => _itemType;
  RecurringCost? get recurringCost => _recurringCost;
  InstallmentPlan? get installmentPlan => _installmentPlan;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get itemName {
    if (_recurringCost != null) return _recurringCost!.name;
    if (_installmentPlan != null) return _installmentPlan!.name;
    return '';
  }

  double get dailyCost {
    if (_recurringCost != null) return _recurringCost!.dailyCost;
    if (_installmentPlan != null) return _installmentPlan!.dailyCost;
    return 0;
  }

  /// Load a recurring cost item for viewing
  void loadRecurringCost(RecurringCost cost) {
    _itemType = CostItemType.recurring;
    _recurringCost = cost;
    _installmentPlan = null;
    notifyListeners();
  }

  /// Load an installment plan for viewing
  void loadInstallmentPlan(InstallmentPlan plan) {
    _itemType = CostItemType.installment;
    _installmentPlan = plan;
    _recurringCost = null;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  /// Update the current recurring cost
  Future<bool> updateRecurringCost(RecurringCost cost) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateRecurringCostUseCase.call(cost);
      _recurringCost = cost;
      _isEditing = false;
      return true;
    } catch (e) {
      _errorMessage = '更新失败: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the current installment plan
  Future<bool> updateInstallmentPlan(InstallmentPlan plan) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateInstallmentPlanUseCase.call(plan);
      _installmentPlan = plan;
      _isEditing = false;
      return true;
    } catch (e) {
      _errorMessage = '更新失败: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete the current item
  Future<bool> deleteItem() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_itemType == CostItemType.recurring && _recurringCost != null) {
        await _deleteRecurringCostUseCase.call(_recurringCost!.id);
      } else if (_itemType == CostItemType.installment &&
          _installmentPlan != null) {
        await _deleteInstallmentPlanUseCase.call(_installmentPlan!.id);
      }
      return true;
    } catch (e) {
      _errorMessage = '删除失败: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
