// cost_item_detail_view.dart
// LifeCostTracker
// 成本项详情页面（查看 + 编辑）

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cost_item_detail_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/cost_category.dart';
import 'add_cost_item_sheet.dart' show CategoryPickerContent;

class CostItemDetailView extends StatefulWidget {
  final RecurringCost? recurringCost;
  final InstallmentPlan? installmentPlan;

  const CostItemDetailView({
    super.key,
    this.recurringCost,
    this.installmentPlan,
  });

  @override
  State<CostItemDetailView> createState() => _CostItemDetailViewState();
}

class _CostItemDetailViewState extends State<CostItemDetailView> {
  bool _isEditing = false;

  // 编辑用的临时字段
  late TextEditingController _nameCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _notesCtrl;
  BillingCycle? _editBasePeriod;
  BillingCycle? _editBillingCycle;
  CostCategory? _editCategory;
  DateTime? _editNextDueDate;

  // 分期编辑字段
  late TextEditingController _monthlyPaymentCtrl;
  late TextEditingController _totalPeriodsCtrl;
  late TextEditingController _paidPeriodsCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _amountCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    _monthlyPaymentCtrl = TextEditingController();
    _totalPeriodsCtrl = TextEditingController();
    _paidPeriodsCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<CostItemDetailViewModel>();
      if (widget.recurringCost != null) {
        vm.loadRecurringCost(widget.recurringCost!);
      } else if (widget.installmentPlan != null) {
        vm.loadInstallmentPlan(widget.installmentPlan!);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    _monthlyPaymentCtrl.dispose();
    _totalPeriodsCtrl.dispose();
    _paidPeriodsCtrl.dispose();
    super.dispose();
  }

  void _startEditing(CostItemDetailViewModel vm) {
    if (vm.recurringCost != null) {
      final c = vm.recurringCost!;
      _nameCtrl.text = c.name;
      _amountCtrl.text = c.amount.toStringAsFixed(2);
      _notesCtrl.text = c.notes ?? '';
      _editBasePeriod = c.basePeriod;
      _editBillingCycle = c.billingCycle;
      _editCategory = c.category;
      _editNextDueDate = c.nextDueDate;
    } else if (vm.installmentPlan != null) {
      final p = vm.installmentPlan!;
      _nameCtrl.text = p.name;
      _monthlyPaymentCtrl.text = p.monthlyPayment.toStringAsFixed(2);
      _totalPeriodsCtrl.text = p.totalPeriods.toString();
      _paidPeriodsCtrl.text = p.paidPeriods.toString();
      _notesCtrl.text = p.notes ?? '';
      _editNextDueDate = p.nextDueDate;
    }
    setState(() => _isEditing = true);
  }

  Future<void> _saveEditing(CostItemDetailViewModel vm) async {
    bool success = false;
    if (vm.recurringCost != null) {
      final updated = vm.recurringCost!.copyWith(
        name: _nameCtrl.text.trim(),
        amount: double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ??
            vm.recurringCost!.amount,
        basePeriod: _editBasePeriod,
        billingCycle: _editBillingCycle,
        category: _editCategory,
        nextDueDate: _editNextDueDate,
        notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      );
      success = await vm.updateRecurringCost(updated);
    } else if (vm.installmentPlan != null) {
      final newPaidPeriods =
          int.tryParse(_paidPeriodsCtrl.text) ?? vm.installmentPlan!.paidPeriods;
      final newTotalPeriods =
          int.tryParse(_totalPeriodsCtrl.text) ?? vm.installmentPlan!.totalPeriods;
      final newMonthly = double.tryParse(
              _monthlyPaymentCtrl.text.replaceAll(',', '.')) ??
          vm.installmentPlan!.monthlyPayment;

      final updated = vm.installmentPlan!.copyWith(
        name: _nameCtrl.text.trim(),
        monthlyPayment: newMonthly,
        totalPeriods: newTotalPeriods,
        paidPeriods: newPaidPeriods,
        totalAmount: newMonthly * newTotalPeriods,
        nextDueDate: _editNextDueDate,
        notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      );
      success = await vm.updateInstallmentPlan(updated);
    }
    if (success) {
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsViewModel>();

    return Consumer<CostItemDetailViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? '编辑' : vm.itemName),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _startEditing(vm),
                  tooltip: '编辑',
                ),
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, vm),
                ),
              if (_isEditing)
                TextButton(
                  onPressed: () => setState(() => _isEditing = false),
                  child: const Text('取消'),
                ),
              if (_isEditing)
                TextButton(
                  onPressed: vm.isLoading ? null : () => _saveEditing(vm),
                  child: const Text('保存'),
                ),
            ],
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isEditing
                  ? _buildEditForm(vm, settings, theme)
                  : _buildViewBody(vm, settings, theme),
        );
      },
    );
  }

  // ===== 查看模式 =====

  Widget _buildViewBody(
    CostItemDetailViewModel vm,
    SettingsViewModel settings,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 每日成本卡片
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '${settings.currency}${vm.dailyCost.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  '每天',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (vm.itemType == CostItemType.recurring && vm.recurringCost != null)
            _buildRecurringView(vm.recurringCost!, settings, theme),

          if (vm.itemType == CostItemType.installment &&
              vm.installmentPlan != null)
            _buildInstallmentView(vm.installmentPlan!, settings, theme),

          // 启用/禁用（周期性）
          if (vm.itemType == CostItemType.recurring &&
              vm.recurringCost != null) ...[
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('启用'),
              subtitle:
                  Text(vm.recurringCost!.isActive ? '计入睡后成本' : '已暂停'),
              value: vm.recurringCost!.isActive,
              onChanged: (value) {
                vm.updateRecurringCost(
                  vm.recurringCost!.copyWith(isActive: value),
                );
              },
            ),
          ],

          if (vm.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(vm.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _buildRecurringView(
      RecurringCost cost, SettingsViewModel settings, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow('名称', cost.name),
            _detailRow('基础周期金额',
                '${settings.currency}${cost.amount.toStringAsFixed(2)} / ${cost.basePeriod.displayName}'),
            if (cost.basePeriod != cost.billingCycle)
              _detailRow('付款周期', cost.billingCycle.displayName),
            if (cost.basePeriod != cost.billingCycle)
              _detailRow('每次实付',
                  '${settings.currency}${cost.paymentAmount.toStringAsFixed(2)}'),
            _detailRow('分类',
                '${cost.category.group.displayName} · ${cost.category.displayName}'),
            _detailRow('下次到期',
                '${cost.nextDueDate.year}-${cost.nextDueDate.month.toString().padLeft(2, '0')}-${cost.nextDueDate.day.toString().padLeft(2, '0')}'),
            _detailRow('月度等价',
                '${settings.currency}${cost.monthlyCost.toStringAsFixed(2)}'),
            _detailRow('年度等价',
                '${settings.currency}${cost.yearlyCost.toStringAsFixed(2)}'),
            if (cost.notes != null && cost.notes!.isNotEmpty)
              _detailRow('备注', cost.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentView(
      InstallmentPlan plan, SettingsViewModel settings, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow('名称', plan.name),
            _detailRow('每月还款',
                '${settings.currency}${plan.monthlyPayment.toStringAsFixed(2)}'),
            _detailRow('总金额',
                '${settings.currency}${plan.totalAmount.toStringAsFixed(2)}'),
            _detailRow('进度', '${plan.paidPeriods}/${plan.totalPeriods} 期'),
            _detailRow('剩余金额',
                '${settings.currency}${plan.remainingAmount.toStringAsFixed(2)}'),
            _detailRow('下次到期',
                '${plan.nextDueDate.year}-${plan.nextDueDate.month.toString().padLeft(2, '0')}-${plan.nextDueDate.day.toString().padLeft(2, '0')}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: plan.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${(plan.progress * 100).toStringAsFixed(0)}% 完成',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
            ),
            if (plan.notes != null && plan.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _detailRow('备注', plan.notes!),
            ],
          ],
        ),
      ),
    );
  }

  // ===== 编辑模式 =====

  Widget _buildEditForm(
    CostItemDetailViewModel vm,
    SettingsViewModel settings,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 名称
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            if (vm.itemType == CostItemType.recurring) ...[
              // 基础周期金额
              TextField(
                controller: _amountCtrl,
                decoration: InputDecoration(
                  labelText: '${_editBasePeriod?.displayName ?? ""}金额',
                  border: const OutlineInputBorder(),
                  prefixText: '¥ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // 基础周期
              DropdownButtonFormField<BillingCycle>(
                value: _editBasePeriod,
                decoration: const InputDecoration(
                  labelText: '基础周期',
                  border: OutlineInputBorder(),
                ),
                items: BillingCycle.values
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c.displayName)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _editBasePeriod = v);
                },
              ),
              const SizedBox(height: 16),

              // 付款周期
              DropdownButtonFormField<BillingCycle>(
                value: _editBillingCycle,
                decoration: const InputDecoration(
                  labelText: '付款周期',
                  border: OutlineInputBorder(),
                ),
                items: BillingCycle.values
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c.displayName)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _editBillingCycle = v);
                },
              ),
              const SizedBox(height: 16),

              // 分类
              GestureDetector(
                onTap: () => _showCategoryPicker(),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '分类',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Row(
                    children: [
                      Icon(_editCategory?.icon, size: 20,
                          color: _editCategory?.group.color),
                      const SizedBox(width: 8),
                      Text(
                          '${_editCategory?.group.displayName} · ${_editCategory?.displayName}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 下次到期日
              _buildNextDueDatePicker(),
            ],

            if (vm.itemType == CostItemType.installment) ...[
              // 每月还款
              TextField(
                controller: _monthlyPaymentCtrl,
                decoration: const InputDecoration(
                  labelText: '每月还款',
                  border: OutlineInputBorder(),
                  prefixText: '¥ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // 总期数
              TextField(
                controller: _totalPeriodsCtrl,
                decoration: const InputDecoration(
                  labelText: '总期数',
                  border: OutlineInputBorder(),
                  suffixText: '期',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // 已付期数
              TextField(
                controller: _paidPeriodsCtrl,
                decoration: const InputDecoration(
                  labelText: '已付期数',
                  border: OutlineInputBorder(),
                  suffixText: '期',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // 下次到期日
              _buildNextDueDatePicker(),
            ],

            const SizedBox(height: 16),

            // 备注
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: '备注（可选）',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextDueDatePicker() {
    final dateStr = _editNextDueDate != null
        ? '${_editNextDueDate!.year}-${_editNextDueDate!.month.toString().padLeft(2, '0')}-${_editNextDueDate!.day.toString().padLeft(2, '0')}'
        : '未设置';
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
        final picked = await showDatePicker(
          context: context,
          initialDate: _editNextDueDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 730)),
          helpText: '选择下次到期日',
        );
        if (picked != null) {
          setState(() => _editNextDueDate = picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '下次到期日',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(dateStr),
      ),
    );
  }

  void _showCategoryPicker() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return CategoryPickerContent(
          currentCategory: _editCategory ?? CostCategory.other,
          onSelected: (cat) {
            setState(() => _editCategory = cat);
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  // ===== 通用 =====

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Flexible(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CostItemDetailViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「${vm.itemName}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await vm.deleteItem();
              if (success && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
