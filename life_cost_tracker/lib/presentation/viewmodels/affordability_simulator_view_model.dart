// affordability_simulator_view_model.dart
// LifeCostTracker
// 承担能力模拟器 ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/affordability_item.dart';
import '../../domain/usecases/simulate_affordability_usecase.dart';
import '../../domain/usecases/manage_affordability_item_usecase.dart';

/// ViewModel for the affordability simulator
/// 承担能力模拟器 ViewModel
class AffordabilitySimulatorViewModel extends ChangeNotifier {
  final SimulateAffordabilityUseCase _simulateUseCase;
  final GetAffordabilityItemsUseCase _getItemsUseCase;
  final AddAffordabilityItemUseCase _addItemUseCase;
  final DeleteAffordabilityItemUseCase _deleteItemUseCase;

  AffordabilitySimulatorViewModel({
    required SimulateAffordabilityUseCase simulateUseCase,
    required GetAffordabilityItemsUseCase getItemsUseCase,
    required AddAffordabilityItemUseCase addItemUseCase,
    required DeleteAffordabilityItemUseCase deleteItemUseCase,
  })  : _simulateUseCase = simulateUseCase,
        _getItemsUseCase = getItemsUseCase,
        _addItemUseCase = addItemUseCase,
        _deleteItemUseCase = deleteItemUseCase;

  // State - input fields
  String _name = '';
  double _totalCost = 0;
  bool _isInstallment = true;
  int _installmentPeriods = 12;
  double _monthlyPayment = 0;

  // State - simulation result
  AffordabilityResult? _result;
  List<AffordabilityItem> _savedItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get name => _name;
  double get totalCost => _totalCost;
  bool get isInstallment => _isInstallment;
  int get installmentPeriods => _installmentPeriods;
  double get monthlyPayment => _monthlyPayment;
  AffordabilityResult? get result => _result;
  List<AffordabilityItem> get savedItems => _savedItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setTotalCost(double value) {
    _totalCost = value;
    if (_installmentPeriods > 0) {
      _monthlyPayment = _totalCost / _installmentPeriods;
    }
    notifyListeners();
  }

  void setIsInstallment(bool value) {
    _isInstallment = value;
    notifyListeners();
  }

  void setInstallmentPeriods(int value) {
    _installmentPeriods = value;
    if (_installmentPeriods > 0) {
      _monthlyPayment = _totalCost / _installmentPeriods;
    }
    notifyListeners();
  }

  void setMonthlyPayment(double value) {
    _monthlyPayment = value;
    notifyListeners();
  }

  /// Load saved simulation items
  Future<void> loadSavedItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedItems = await _getItemsUseCase.call();
    } catch (e) {
      _errorMessage = '加载失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Run simulation with current input
  /// 使用当前输入运行模拟
  Future<void> simulate() async {
    if (_name.trim().isEmpty || _totalCost <= 0) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final item = AffordabilityItem(
        name: _name.trim(),
        totalCost: _totalCost,
        isInstallment: _isInstallment,
        installmentPeriods: _isInstallment ? _installmentPeriods : null,
        monthlyPayment: _isInstallment ? _monthlyPayment : null,
      );

      _result = await _simulateUseCase.call(item);
    } catch (e) {
      _errorMessage = '模拟失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save current simulation as a saved item
  Future<void> saveCurrentItem() async {
    if (_name.trim().isEmpty || _totalCost <= 0) return;

    final item = AffordabilityItem(
      name: _name.trim(),
      totalCost: _totalCost,
      isInstallment: _isInstallment,
      installmentPeriods: _isInstallment ? _installmentPeriods : null,
      monthlyPayment: _isInstallment ? _monthlyPayment : null,
    );

    await _addItemUseCase.call(item);
    await loadSavedItems();
  }

  /// Delete a saved item
  Future<void> deleteSavedItem(String id) async {
    await _deleteItemUseCase.call(id);
    await loadSavedItems();
  }

  /// Reset form
  void resetForm() {
    _name = '';
    _totalCost = 0;
    _isInstallment = true;
    _installmentPeriods = 12;
    _monthlyPayment = 0;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
