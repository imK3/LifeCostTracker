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
  double _amount = 0; // 基础周期金额（用户心智金额）
  BillingCycle _basePeriod = BillingCycle.monthly; // 基础周期（用户心智周期）
  BillingCycle _billingCycle = BillingCycle.monthly; // 实际账单周期
  CostCategory _category = CostCategory.other;
  int _dueDay = 1; // 每月几号到期
  bool _alreadyPaid = false; // 本期是否已支付

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
  BillingCycle get basePeriod => _basePeriod;
  BillingCycle get billingCycle => _billingCycle;

  /// 实际付款金额预览
  double get previewPaymentAmount =>
      _amount * _billingCycle.multiplierFrom(_basePeriod);
  CostCategory get category => _category;
  int get dueDay => _dueDay;
  bool get alreadyPaid => _alreadyPaid;
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
      return _amount / _basePeriod.daysInCycle;
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

  void setBasePeriod(BillingCycle value) {
    _basePeriod = value;
    notifyListeners();
  }

  void setBillingCycle(BillingCycle value) {
    _billingCycle = value;
    // Re-clamp dueDay for the new cycle's valid range
    _dueDay = value.clampDueDay(_dueDay);
    notifyListeners();
  }

  void setCategory(CostCategory value) {
    _category = value;
    notifyListeners();
  }

  void setDueDay(int value) {
    _dueDay = _billingCycle.clampDueDay(value);
    notifyListeners();
  }

  void setAlreadyPaid(bool value) {
    _alreadyPaid = value;
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
        final now = DateTime.now();
        // Calculate next due date based on billingCycle and dueDay
        final nextDue = _calculateNextDueDate(now);

        final cost = RecurringCost(
          name: _name.trim(),
          amount: _amount,
          basePeriod: _basePeriod,
          billingCycle: _billingCycle,
          category: _category,
          startDate: now,
          nextDueDate: nextDue,
          isPaidForCurrentPeriod: _alreadyPaid,
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

  /// Calculate next due date based on billing cycle and dueDay input
  /// 根据账单周期和到期日输入计算下一个到期日
  ///
  /// dueDay 的含义随 billingCycle 变化：
  /// - weekly: 周几（1-7）
  /// - monthly/quarterly: 几号（1-31）
  /// - yearly: 几月（1-12）
  DateTime _calculateNextDueDate(DateTime now) {
    switch (_billingCycle) {
      case BillingCycle.weekly:
        // dueDay = 1(周一) ~ 7(周日)
        final currentWeekday = now.weekday; // 1=Mon, 7=Sun
        var daysUntil = _dueDay - currentWeekday;
        if (daysUntil <= 0 || _alreadyPaid) daysUntil += 7;
        return DateTime(now.year, now.month, now.day + daysUntil);

      case BillingCycle.monthly:
        var nextDue = DateTime(now.year, now.month, _dueDay);
        if (nextDue.isBefore(now) || _alreadyPaid) {
          nextDue = DateTime(now.year, now.month + 1, _dueDay);
        }
        return nextDue;

      case BillingCycle.quarterly:
        var nextDue = DateTime(now.year, now.month, _dueDay);
        if (nextDue.isBefore(now) || _alreadyPaid) {
          nextDue = DateTime(now.year, now.month + 3, _dueDay);
        }
        return nextDue;

      case BillingCycle.yearly:
        // dueDay = month (1-12), pay on the 1st of that month
        var nextDue = DateTime(now.year, _dueDay, 1);
        if (nextDue.isBefore(now) || _alreadyPaid) {
          nextDue = DateTime(now.year + 1, _dueDay, 1);
        }
        return nextDue;
    }
  }

  /// Reset the form
  void reset() {
    _currentStep = 0;
    _selectedType = null;
    _name = '';
    _amount = 0;
    _basePeriod = BillingCycle.monthly;
    _billingCycle = BillingCycle.monthly;
    _category = CostCategory.other;
    _dueDay = 1;
    _alreadyPaid = false;
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
