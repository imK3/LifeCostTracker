// add_cost_item_sheet.dart
// LifeCostTracker
// 添加成本项底部弹窗

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/add_cost_item_view_model.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/cost_category.dart';

class AddCostItemSheet extends StatelessWidget {
  const AddCostItemSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddCostItemViewModel>(
      builder: (context, vm, child) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    vm.currentStep == 0 ? '添加成本项' : '填写详情',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step 0: Select type
                  if (vm.currentStep == 0) ...[
                    _buildTypeCard(
                      context,
                      icon: Icons.repeat,
                      title: '周期性支出',
                      description: '房租、水电、伙食、订阅、话费等固定周期支出',
                      onTap: () =>
                          vm.selectType(AddCostItemType.recurring),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeCard(
                      context,
                      icon: Icons.credit_card,
                      title: '分期承诺',
                      description: '手机分期、贷款等有固定期数的还款计划',
                      onTap: () =>
                          vm.selectType(AddCostItemType.installment),
                    ),
                  ],

                  // Step 1: Fill details
                  if (vm.currentStep == 1) ...[
                    // Back button
                    TextButton.icon(
                      onPressed: vm.goBack,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('返回'),
                    ),
                    const SizedBox(height: 8),

                    // Name field
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '名称',
                        hintText: '例如：房租、Claude Code Max',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: vm.setName,
                    ),
                    const SizedBox(height: 16),

                    if (vm.selectedType == AddCostItemType.recurring) ...[
                      // Base period — 用户心智周期
                      DropdownButtonFormField<BillingCycle>(
                        initialValue: vm.basePeriod,
                        decoration: const InputDecoration(
                          labelText: '基础周期',
                          helperText: '你习惯怎么理解这笔费用',
                          border: OutlineInputBorder(),
                        ),
                        items: BillingCycle.values
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.displayName),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) vm.setBasePeriod(v);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Amount field — 基础周期金额
                      TextField(
                        decoration: InputDecoration(
                          labelText: '${vm.basePeriod.displayName}金额',
                          hintText: '例如：月租4500',
                          border: const OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            vm.setAmount(double.tryParse(v) ?? 0),
                      ),
                      const SizedBox(height: 16),

                      // Billing cycle — 实际付款周期
                      DropdownButtonFormField<BillingCycle>(
                        initialValue: vm.billingCycle,
                        decoration: const InputDecoration(
                          labelText: '付款周期',
                          helperText: '实际多久付一次款',
                          border: OutlineInputBorder(),
                        ),
                        items: BillingCycle.values
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.displayName),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) vm.setBillingCycle(v);
                        },
                      ),

                      // 当基础周期≠付款周期时，显示实际付款金额
                      if (vm.basePeriod != vm.billingCycle &&
                          vm.amount > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 16, color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Text(
                                '每次实际付款 ¥${vm.previewPaymentAmount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Category (grouped by CostCategoryGroup)
                      DropdownButtonFormField<CostCategory>(
                        initialValue: vm.category,
                        decoration: const InputDecoration(
                          labelText: '分类',
                          border: OutlineInputBorder(),
                        ),
                        items: CostCategoryGroup.values
                            .expand((group) {
                              final cats = CostCategory.values
                                  .where((c) => c.group == group)
                                  .toList();
                              return [
                                DropdownMenuItem<CostCategory>(
                                  enabled: false,
                                  child: Text(
                                    group.displayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: group.color,
                                    ),
                                  ),
                                ),
                                ...cats.map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 12),
                                          Icon(c.icon, size: 20),
                                          const SizedBox(width: 8),
                                          Text(c.displayName),
                                        ],
                                      ),
                                    )),
                              ];
                            })
                            .toList(),
                        onChanged: (v) {
                          if (v != null) vm.setCategory(v);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Due day (adapts to billing cycle)
                      TextField(
                        decoration: InputDecoration(
                          labelText: vm.billingCycle.dueDateLabel,
                          hintText: vm.billingCycle.dueDateHint,
                          border: const OutlineInputBorder(),
                          suffixText: vm.billingCycle.dueDateSuffix,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            vm.setDueDay(int.tryParse(v) ?? 1),
                      ),
                      const SizedBox(height: 12),

                      // Already paid toggle
                      SwitchListTile(
                        title: const Text('本期已支付'),
                        subtitle: const Text('如果这个月/这期已经付过了'),
                        value: vm.alreadyPaid,
                        onChanged: vm.setAlreadyPaid,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],

                    if (vm.selectedType ==
                        AddCostItemType.installment) ...[
                      // Total amount
                      TextField(
                        decoration: const InputDecoration(
                          labelText: '总金额',
                          hintText: '商品总价',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            vm.setTotalAmount(double.tryParse(v) ?? 0),
                      ),
                      const SizedBox(height: 16),

                      // Total periods
                      TextField(
                        decoration: const InputDecoration(
                          labelText: '分期期数',
                          hintText: '例如：12',
                          border: OutlineInputBorder(),
                          suffixText: '期',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            vm.setTotalPeriods(int.tryParse(v) ?? 0),
                      ),
                      const SizedBox(height: 16),

                      // Monthly payment (auto-calculated)
                      TextField(
                        decoration: InputDecoration(
                          labelText: '每月还款',
                          hintText: vm.monthlyPayment > 0
                              ? vm.monthlyPayment.toStringAsFixed(2)
                              : '自动计算或手动输入',
                          border: const OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => vm.setMonthlyPayment(
                            double.tryParse(v) ?? 0),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Notes
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '备注（可选）',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (v) => vm.setNotes(v.isEmpty ? null : v),
                    ),

                    const SizedBox(height: 20),

                    // Daily cost preview
                    if (vm.previewDailyCost > 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('每日成本增加 '),
                            Text(
                              '¥${vm.previewDailyCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Validation errors
                    if (vm.validationErrors.isNotEmpty)
                      ...vm.validationErrors.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(e,
                                style:
                                    const TextStyle(color: Colors.red)),
                          )),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: vm.canSave && !vm.isSaving
                            ? () async {
                                final success = await vm.save();
                                if (success && context.mounted) {
                                  vm.reset();
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        child: vm.isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Text('保存'),
                      ),
                    ),

                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(vm.errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    size: 28, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(description,
                        style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.outline)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
