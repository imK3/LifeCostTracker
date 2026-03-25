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
  DateTime? _lastPaidDate; // 上次支付日期

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
  DateTime? get lastPaidDate => _lastPaidDate;
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

  void setLastPaidDate(DateTime? value) {
    _lastPaidDate = value;
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

        // 如果有上次支付日期且 nextDue 在未来，说明本期已支付
        final isPaid = _lastPaidDate != null && nextDue.isAfter(now);

        final cost = RecurringCost(
          name: _name.trim(),
          amount: _amount,
          basePeriod: _basePeriod,
          billingCycle: _billingCycle,
          category: _category,
          startDate: now,
          nextDueDate: nextDue,
          isPaidForCurrentPeriod: isPaid,
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
  /// 如果提供了上次支付日期，从该日期推算下次到期日
  /// 否则根据 dueDay 计算（dueDay 含义随 billingCycle 变化）
  DateTime _calculateNextDueDate(DateTime now) {
    // 如果有上次支付日期，从该日期推算下一个到期日
    if (_lastPaidDate != null) {
      final paid = _lastPaidDate!;
      DateTime nextDue;
      switch (_billingCycle) {
        case BillingCycle.weekly:
          nextDue = DateTime(paid.year, paid.month, paid.day + 7);
        case BillingCycle.monthly:
          nextDue = DateTime(paid.year, paid.month + 1, paid.day);
        case BillingCycle.quarterly:
          nextDue = DateTime(paid.year, paid.month + 3, paid.day);
        case BillingCycle.yearly:
          nextDue = DateTime(paid.year + 1, paid.month, paid.day);
      }
      // 如果推算出的下次到期日已过，继续往前推
      while (nextDue.isBefore(now)) {
        switch (_billingCycle) {
          case BillingCycle.weekly:
            nextDue = DateTime(nextDue.year, nextDue.month, nextDue.day + 7);
          case BillingCycle.monthly:
            nextDue = DateTime(nextDue.year, nextDue.month + 1, nextDue.day);
          case BillingCycle.quarterly:
            nextDue = DateTime(nextDue.year, nextDue.month + 3, nextDue.day);
          case BillingCycle.yearly:
            nextDue = DateTime(nextDue.year + 1, nextDue.month, nextDue.day);
        }
      }
      return nextDue;
    }

    // 没有上次支付日期，根据 dueDay 计算
    switch (_billingCycle) {
      case BillingCycle.weekly:
        final currentWeekday = now.weekday;
        var daysUntil = _dueDay - currentWeekday;
        if (daysUntil <= 0) daysUntil += 7;
        return DateTime(now.year, now.month, now.day + daysUntil);

      case BillingCycle.monthly:
        var nextDue = DateTime(now.year, now.month, _dueDay);
        if (nextDue.isBefore(now)) {
          nextDue = DateTime(now.year, now.month + 1, _dueDay);
        }
        return nextDue;

      case BillingCycle.quarterly:
        var nextDue = DateTime(now.year, now.month, _dueDay);
        if (nextDue.isBefore(now)) {
          nextDue = DateTime(now.year, now.month + 3, _dueDay);
        }
        return nextDue;

      case BillingCycle.yearly:
        var nextDue = DateTime(now.year, _dueDay, 1);
        if (nextDue.isBefore(now)) {
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
    _lastPaidDate = null;
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
