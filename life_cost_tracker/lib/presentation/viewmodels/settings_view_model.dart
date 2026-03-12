// settings_view_model.dart
// LifeCostTracker
// 设置 ViewModel

import 'package:flutter/foundation.dart';
import '../../domain/entities/display_cycle.dart';

/// ViewModel for settings
/// 设置 ViewModel
class SettingsViewModel extends ChangeNotifier {
  DisplayCycle _displayCycle = DisplayCycle.daily;
  String _currency = '¥';

  DisplayCycle get displayCycle => _displayCycle;
  String get currency => _currency;

  void setDisplayCycle(DisplayCycle cycle) {
    _displayCycle = cycle;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }
}
