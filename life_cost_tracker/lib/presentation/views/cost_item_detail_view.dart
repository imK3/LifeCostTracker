// cost_item_detail_view.dart
// LifeCostTracker
// 成本项详情页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cost_item_detail_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';

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
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsViewModel>();

    return Consumer<CostItemDetailViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.itemName),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, vm),
              ),
            ],
          ),
          body: _buildBody(context, vm, settings, theme),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    CostItemDetailViewModel vm,
    SettingsViewModel settings,
    ThemeData theme,
  ) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero card with daily cost
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

          // Details
          if (vm.itemType == CostItemType.recurring &&
              vm.recurringCost != null)
            _buildRecurringDetails(vm.recurringCost!, settings, theme),

          if (vm.itemType == CostItemType.installment &&
              vm.installmentPlan != null)
            _buildInstallmentDetails(vm.installmentPlan!, settings, theme),

          // Toggle active (recurring only)
          if (vm.itemType == CostItemType.recurring &&
              vm.recurringCost != null) ...[
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('启用'),
              subtitle: Text(vm.recurringCost!.isActive ? '计入睡后成本' : '已暂停'),
              value: vm.recurringCost!.isActive,
              onChanged: (value) {
                vm.updateRecurringCost(
                  vm.recurringCost!.copyWith(isActive: value),
                );
              },
            ),
          ],

          // Error message
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

  Widget _buildRecurringDetails(
    RecurringCost cost,
    SettingsViewModel settings,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow('名称', cost.name),
            _detailRow('金额',
                '${settings.currency}${cost.amount.toStringAsFixed(2)}'),
            _detailRow('周期', cost.billingCycle.displayName),
            _detailRow('分类', cost.category.displayName),
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

  Widget _buildInstallmentDetails(
    InstallmentPlan plan,
    SettingsViewModel settings,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow('名称', plan.name),
            _detailRow('总金额',
                '${settings.currency}${plan.totalAmount.toStringAsFixed(2)}'),
            _detailRow('月供',
                '${settings.currency}${plan.monthlyPayment.toStringAsFixed(2)}'),
            _detailRow('进度', '${plan.paidPeriods}/${plan.totalPeriods} 期'),
            _detailRow('剩余金额',
                '${settings.currency}${plan.remainingAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: plan.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${(plan.progress * 100).toStringAsFixed(0)}% 完成',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.outline,
              ),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade600)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, CostItemDetailViewModel vm) {
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
