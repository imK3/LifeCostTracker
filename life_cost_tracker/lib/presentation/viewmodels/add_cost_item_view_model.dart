// add_cost_item_view_model.dart
// LifeCostTracker
// 添加成本项 ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/cost_category.dart';
import '../../domain/usecases/manage_recurring_cost_usecase.dart';
import '../../domain/usecases/manage_installment_plan_usecase.dart';

/// Type of cost item being added
/// 添加的成本项类型
enum AddCostItemType {
  /// Recurring cost (fixed living or subscription)
  /// 周期性成本（固定生活或订阅）
  recurring,

  /// Installment plan
  /// 分期承诺
  installment,
}

/// ViewModel for adding a new cost item
/// 添加成本项的 ViewModel
class AddCostItemViewModel extends ChangeNotifier {
  final AddRecurringCostUseCase _addRecurringCostUseCase;
  final AddInstallmentPlanUseCase _addInstallmentPlanUseCase;

  AddCostItemViewModel({
    required AddRecurringCostUseCase addRecurringCostUseCase,
    required AddInstallmentPlanUseCase addInstallmentPlanUseCase,
  })  : _addRecurringCostUseCase = addRecurringCostUseCase,
        _addInstallmentPlanUseCase = addInstallmentPlanUseCase;

  // State - step flow
  int _currentStep = 0;
  AddCostItemType? _selectedType;

  // State - recurring cost fields
  String _name = '';
  double _amount = 0;
  BillingCycle _billingCycle = BillingCycle.monthly;
  CostCategory _category = CostCategory.other;

  // State - installment plan fields
  double _totalAmount = 0;
  int _totalPeriods = 12;
  double _monthlyPayment = 0;

  // State - general
  String? _notes;
  bool _isSaving = false;
  String? _errorMessage;
  List<String> _validationErrors = [];

  // Getters
  int get currentStep => _currentStep;
  AddCostItemType? get selectedType => _selectedType;
  String get name => _name;
  double get amount => _amount;
  BillingCycle get billingCycle => _billingCycle;
  CostCategory get category => _category;
  double get totalAmount => _totalAmount;
  int get totalPeriods => _totalPeriods;
  double get monthlyPayment => _monthlyPayment;
  String? get notes => _notes;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  List<String> get validationErrors => _validationErrors;

  /// Preview daily cost for the current input
  /// 预览当前输入的每日成本
  double get previewDailyCost {
    if (_selectedType == AddCostItemType.recurring) {
      return _amount / _billingCycle.daysInCycle;
    } else if (_selectedType == AddCostItemType.installment) {
      return _monthlyPayment / 30;
    }
    return 0;
  }

  // Step navigation
  void selectType(AddCostItemType type) {
    _selectedType = type;
    _currentStep = 1;
    notifyListeners();
  }

  void goBack() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Field setters
  void setName(String value) {
    _name = value;
    _validateFields();
  }

  void setAmount(double value) {
    _amount = value;
    _validateFields();
  }

  void setBillingCycle(BillingCycle value) {
    _billingCycle = value;
    notifyListeners();
  }

  void setCategory(CostCategory value) {
    _category = value;
    notifyListeners();
  }

  void setTotalAmount(double value) {
    _totalAmount = value;
    if (_totalPeriods > 0) {
      _monthlyPayment = _totalAmount / _totalPeriods;
    }
    _validateFields();
  }

  void setTotalPeriods(int value) {
    _totalPeriods = value;
    if (_totalPeriods > 0) {
      _monthlyPayment = _totalAmount / _totalPeriods;
    }
    _validateFields();
  }

  void setMonthlyPayment(double value) {
    _monthlyPayment = value;
    _validateFields();
  }

  void setNotes(String? value) {
    _notes = value;
  }

  /// Validate input fields
  void _validateFields() {
    _validationErrors = [];
    if (_name.trim().isEmpty) {
      _validationErrors.add('请输入名称');
    }
    if (_selectedType == AddCostItemType.recurring && _amount <= 0) {
      _validationErrors.add('金额必须大于 0');
    }
    if (_selectedType == AddCostItemType.installment) {
      if (_totalAmount <= 0) _validationErrors.add('总金额必须大于 0');
      if (_totalPeriods <= 0) _validationErrors.add('期数必须大于 0');
      if (_monthlyPayment <= 0) _validationErrors.add('月供必须大于 0');
    }
    notifyListeners();
  }

  /// Whether the form is valid and can be saved
  bool get canSave =>
      _name.trim().isNotEmpty &&
      _validationErrors.isEmpty &&
      _selectedType != null;

  /// Save the cost item
  /// 保存成本项
  Future<bool> save() async {
    _validateFields();
    if (!canSave) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_selectedType == AddCostItemType.recurring) {
        final cost = RecurringCost(
          name: _name.trim(),
          amount: _amount,
          billingCycle: _billingCycle,
          category: _category,
          startDate: DateTime.now(),
          notes: _notes,
        );
        await _addRecurringCostUseCase.call(cost);
      } else if (_selectedType == AddCostItemType.installment) {
        final plan = InstallmentPlan(
          name: _name.trim(),
          totalAmount: _totalAmount,
          totalPeriods: _totalPeriods,
          paidPeriods: 0,
          monthlyPayment: _monthlyPayment,
          startDate: DateTime.now(),
          notes: _notes,
        );
        await _addInstallmentPlanUseCase.call(plan);
      }
      return true;
    } catch (e) {
      _errorMessage = '保存失败: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Reset the form
  void reset() {
    _currentStep = 0;
    _selectedType = null;
    _name = '';
    _amount = 0;
    _billingCycle = BillingCycle.monthly;
    _category = CostCategory.other;
    _totalAmount = 0;
    _totalPeriods = 12;
    _monthlyPayment = 0;
    _notes = null;
    _isSaving = false;
    _errorMessage = null;
    _validationErrors = [];
    notifyListeners();
  }
}
