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
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) =>
                            vm.setAmount(AddCostItemViewModel.parseNumber(v) ?? 0),
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

                      // Category picker (two-level)
                      _buildCategoryPicker(context, vm),
                      const SizedBox(height: 16),

                      // Due day (adapts to billing cycle)
                      TextField(
                        decoration: InputDecoration(
                          labelText: vm.billingCycle.dueDateLabel,
                          hintText: vm.billingCycle.dueDateHint,
                          border: const OutlineInputBorder(),
                          suffixText: vm.billingCycle.dueDateSuffix,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) =>
                            vm.setDueDay(int.tryParse(v) ?? 1),
                      ),
                      const SizedBox(height: 12),

                      // Last paid date picker
                      _buildLastPaidDatePicker(context, vm),
                    ],

                    if (vm.selectedType ==
                        AddCostItemType.installment) ...[
                      // Monthly payment
                      TextField(
                        decoration: const InputDecoration(
                          labelText: '每月还款',
                          hintText: '每期还多少',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) => vm.setMonthlyPayment(
                            AddCostItemViewModel.parseNumber(v) ?? 0),
                      ),
                      const SizedBox(height: 16),

                      // Total periods
                      TextField(
                        decoration: const InputDecoration(
                          labelText: '总期数',
                          hintText: '例如：12',
                          border: OutlineInputBorder(),
                          suffixText: '期',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) =>
                            vm.setTotalPeriods(int.tryParse(v) ?? 0),
                      ),

                      // 总金额预览
                      if (vm.monthlyPayment > 0 && vm.totalPeriods > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                '总金额 ¥${(vm.monthlyPayment * vm.totalPeriods).toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // 已支付/尚未支付 切换
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('已有还款'),
                              selected: vm.installmentHasPaid,
                              onSelected: (_) =>
                                  vm.setInstallmentHasPaid(true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('尚未支付'),
                              selected: !vm.installmentHasPaid,
                              onSelected: (_) =>
                                  vm.setInstallmentHasPaid(false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (vm.installmentHasPaid) ...[
                        // 已支付期数
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '已支付期数',
                            hintText: '已还了几期',
                            border: OutlineInputBorder(),
                            suffixText: '期',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => vm.setInstallmentPaidPeriods(
                              int.tryParse(v) ?? 0),
                        ),
                        const SizedBox(height: 16),

                        // 上次还款日期
                        _buildInstallmentLastPaidDate(context, vm),
                      ],

                      if (!vm.installmentHasPaid) ...[
                        // 还款日（每月几号）
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '每月还款日',
                            hintText: '每月几号扣款',
                            border: OutlineInputBorder(),
                            suffixText: '号',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => vm.setInstallmentDueDay(
                              int.tryParse(v) ?? 1),
                        ),
                      ],

                      // 剩余期数提示
                      if (vm.installmentHasPaid &&
                          vm.totalPeriods > 0 &&
                          vm.installmentPaidPeriods > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 16, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                '已还 ${vm.installmentPaidPeriods}/${vm.totalPeriods} 期，剩余 ${vm.totalPeriods - vm.installmentPaidPeriods} 期',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
            ),
            );
          },
        );
      },
    );
  }

  /// 上次支付日期选择器
  Widget _buildLastPaidDatePicker(
      BuildContext context, AddCostItemViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '上次支付日期',
          style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (!context.mounted) return;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: vm.lastPaidDate ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 730)),
                    lastDate: DateTime.now(),
                    helpText: '选择上次支付日期',
                  );
                  if (picked != null) {
                    vm.setLastPaidDate(picked);
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  vm.lastPaidDate != null
                      ? '${vm.lastPaidDate!.year}-${vm.lastPaidDate!.month.toString().padLeft(2, '0')}-${vm.lastPaidDate!.day.toString().padLeft(2, '0')}'
                      : '选择日期（可选）',
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ),
            if (vm.lastPaidDate != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => vm.setLastPaidDate(null),
                icon: const Icon(Icons.clear, size: 20),
                tooltip: '清除',
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          vm.lastPaidDate != null ? '将根据此日期推算下次到期日' : '不选则根据到期日字段推算',
          style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
        ),
      ],
    );
  }

  /// 分期 - 上次还款日期选择器
  Widget _buildInstallmentLastPaidDate(
      BuildContext context, AddCostItemViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '上次还款日期',
          style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (!context.mounted) return;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: vm.installmentLastPaidDate ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 730)),
                    lastDate: DateTime.now(),
                    helpText: '选择上次还款日期',
                  );
                  if (picked != null) {
                    vm.setInstallmentLastPaidDate(picked);
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  vm.installmentLastPaidDate != null
                      ? '${vm.installmentLastPaidDate!.year}-${vm.installmentLastPaidDate!.month.toString().padLeft(2, '0')}-${vm.installmentLastPaidDate!.day.toString().padLeft(2, '0')}'
                      : '选择日期',
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ),
            if (vm.installmentLastPaidDate != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => vm.setInstallmentLastPaidDate(null),
                icon: const Icon(Icons.clear, size: 20),
                tooltip: '清除',
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// 分类选择器 - 点击弹出二级菜单
  Widget _buildCategoryPicker(
      BuildContext context, AddCostItemViewModel vm) {
    return GestureDetector(
      onTap: () => _showCategoryPickerDialog(context, vm),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '分类',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Row(
          children: [
            Icon(vm.category.icon, size: 20, color: vm.category.group.color),
            const SizedBox(width: 8),
            Text('${vm.category.group.displayName} · ${vm.category.displayName}'),
          ],
        ),
      ),
    );
  }

  /// 二级分类选择弹窗
  void _showCategoryPickerDialog(
      BuildContext context, AddCostItemViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CategoryPickerContent(
          currentCategory: vm.category,
          onSelected: (cat) {
            vm.setCategory(cat);
            Navigator.of(context).pop();
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

/// 二级分类选择器内容（StatefulWidget 管理选中的 group）
class CategoryPickerContent extends StatefulWidget {
  final CostCategory currentCategory;
  final ValueChanged<CostCategory> onSelected;

  const CategoryPickerContent({
    required this.currentCategory,
    required this.onSelected,
  });

  @override
  State<CategoryPickerContent> createState() =>
      _CategoryPickerContentState();
}

class _CategoryPickerContentState extends State<CategoryPickerContent> {
  late CostCategoryGroup _selectedGroup;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.currentCategory.group;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const groups = CostCategoryGroup.values;

    // 当前组下的子分类（支持搜索过滤）
    List<CostCategory> subcategories;
    if (_searchText.isNotEmpty) {
      // 搜索模式：显示所有匹配的子分类
      subcategories = CostCategory.values
          .where((c) => c.displayName.contains(_searchText))
          .toList();
    } else {
      subcategories = CostCategory.values
          .where((c) => c.group == _selectedGroup)
          .toList();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索分类...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
          ),
          const SizedBox(height: 12),

          // 左右两栏
          Expanded(
            child: Row(
              children: [
                // 左栏：大类
                SizedBox(
                  width: 100,
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final isSelected =
                          group == _selectedGroup && _searchText.isEmpty;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedGroup = group;
                            _searchText = '';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surfaceContainerLow,
                            border: Border(
                              left: BorderSide(
                                color: isSelected
                                    ? group.color
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(group.icon,
                                  size: 22,
                                  color: isSelected
                                      ? group.color
                                      : theme.colorScheme.outline),
                              const SizedBox(height: 4),
                              Text(
                                group.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? group.color
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 右栏：子分类
                Expanded(
                  child: subcategories.isEmpty
                      ? Center(
                          child: Text('无匹配分类',
                              style:
                                  TextStyle(color: theme.colorScheme.outline)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: subcategories.length,
                          itemBuilder: (context, index) {
                            final cat = subcategories[index];
                            final isCurrentSelected =
                                cat == widget.currentCategory;
                            return ListTile(
                              leading: Icon(cat.icon,
                                  color: cat.group.color, size: 22),
                              title: Text(cat.displayName),
                              subtitle: _searchText.isNotEmpty
                                  ? Text(cat.group.displayName,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.outline))
                                  : null,
                              trailing: isCurrentSelected
                                  ? Icon(Icons.check,
                                      color: theme.colorScheme.primary)
                                  : null,
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              selected: isCurrentSelected,
                              onTap: () => widget.onSelected(cat),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
