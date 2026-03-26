// affordability_simulator_view.dart
// LifeCostTracker
// 承担能力模拟器页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/affordability_simulator_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../viewmodels/sleep_cost_dashboard_view_model.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/cost_category.dart';
import 'add_cost_item_sheet.dart' show CategoryPickerContent;

class AffordabilitySimulatorView extends StatefulWidget {
  const AffordabilitySimulatorView({super.key});

  @override
  State<AffordabilitySimulatorView> createState() =>
      _AffordabilitySimulatorViewState();
}

class _AffordabilitySimulatorViewState
    extends State<AffordabilitySimulatorView> {
  CostCategory _simCategory = CostCategory.other;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AffordabilitySimulatorViewModel>().loadSavedItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsViewModel>();
    final dashVm = context.watch<SleepCostDashboardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('承担能力模拟'),
      ),
      body: Consumer<AffordabilitySimulatorViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 输入卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '如果我要买...',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // 类型选择
                          Row(
                            children: [
                              Expanded(
                                child: ChoiceChip(
                                  label: const Text('分期承诺'),
                                  selected: vm.isInstallment,
                                  onSelected: (_) =>
                                      vm.setIsInstallment(true),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ChoiceChip(
                                  label: const Text('周期性支出'),
                                  selected: !vm.isInstallment,
                                  onSelected: (_) =>
                                      vm.setIsInstallment(false),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 名称
                          TextField(
                            decoration: const InputDecoration(
                              labelText: '名称',
                              hintText: '例如：iPhone 16 Pro',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: vm.setName,
                          ),
                          const SizedBox(height: 12),

                          if (vm.isInstallment) ...[
                            // 分期输入模式切换
                            Row(
                              children: [
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Text('按每期金额'),
                                    selected: !vm.installmentByTotal,
                                    onSelected: (_) =>
                                        vm.setInstallmentByTotal(false),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Text('按总金额'),
                                    selected: vm.installmentByTotal,
                                    onSelected: (_) =>
                                        vm.setInstallmentByTotal(true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (vm.installmentByTotal) ...[
                              // 总金额 + 期数
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: '总金额',
                                        border: OutlineInputBorder(),
                                        prefixText: '¥ ',
                                      ),
                                      keyboardType: const TextInputType
                                          .numberWithOptions(decimal: true),
                                      onChanged: (v) => vm.setTotalCost(
                                          double.tryParse(v.replaceAll(
                                                  ',', '.')) ??
                                              0),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: '期数',
                                        border: OutlineInputBorder(),
                                        suffixText: '期',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) =>
                                          vm.setInstallmentPeriods(
                                              int.tryParse(v) ?? 12),
                                    ),
                                  ),
                                ],
                              ),
                              if (vm.totalCost > 0 &&
                                  vm.installmentPeriods > 0) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '每期 ${settings.currency}${vm.monthlyPayment.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.outline),
                                ),
                              ],
                            ] else ...[
                              // 每期金额 + 期数
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: '每期金额',
                                        border: OutlineInputBorder(),
                                        prefixText: '¥ ',
                                      ),
                                      keyboardType: const TextInputType
                                          .numberWithOptions(decimal: true),
                                      onChanged: (v) => vm.setMonthlyPayment(
                                          double.tryParse(v.replaceAll(
                                                  ',', '.')) ??
                                              0),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: '期数',
                                        border: OutlineInputBorder(),
                                        suffixText: '期',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) =>
                                          vm.setInstallmentPeriods(
                                              int.tryParse(v) ?? 12),
                                    ),
                                  ),
                                ],
                              ),
                              if (vm.monthlyPayment > 0 &&
                                  vm.installmentPeriods > 0) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '总价 ${settings.currency}${vm.totalCost.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.outline),
                                ),
                              ],
                            ],
                          ] else ...[
                            // 周期性：周期选择 + 金额
                            Wrap(
                              spacing: 8,
                              children: [
                                for (final cycle in [
                                  BillingCycle.monthly,
                                  BillingCycle.quarterly,
                                  BillingCycle.yearly,
                                ])
                                  ChoiceChip(
                                    label: Text(cycle.displayName),
                                    selected: vm.recurringCycle == cycle,
                                    onSelected: (_) =>
                                        vm.setRecurringCycle(cycle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              decoration: InputDecoration(
                                labelText: '${vm.recurringCycle.displayName}金额',
                                border: const OutlineInputBorder(),
                                prefixText: '¥ ',
                                hintText: vm.recurringCycle == BillingCycle.monthly
                                    ? '例如：月租500'
                                    : vm.recurringCycle == BillingCycle.quarterly
                                        ? '例如：季付1500'
                                        : '例如：年费6000',
                              ),
                              keyboardType: const TextInputType
                                  .numberWithOptions(decimal: true),
                              onChanged: (v) {
                                final val = double.tryParse(
                                        v.replaceAll(',', '.')) ??
                                    0;
                                vm.setRecurringAmount(val);
                              },
                            ),
                            if (vm.recurringAmount > 0 &&
                                vm.recurringCycle != BillingCycle.monthly) ...[
                              const SizedBox(height: 8),
                              Text(
                                '≈ ${settings.currency}${vm.monthlyPayment.toStringAsFixed(2)}/月',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.outline),
                              ),
                            ],
                            const SizedBox(height: 12),

                            // 分类选择
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (ctx) => CategoryPickerContent(
                                    currentCategory: _simCategory,
                                    onSelected: (cat) {
                                      setState(() => _simCategory = cat);
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                );
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '分类',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                child: Row(
                                  children: [
                                    Icon(_simCategory.icon,
                                        size: 20,
                                        color: _simCategory.group.color),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${_simCategory.group.displayName} · ${_simCategory.displayName}'),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // 模拟按钮
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed:
                                  vm.name.isNotEmpty && vm.monthlyPayment > 0
                                      ? vm.simulate
                                      : null,
                              icon: const Icon(Icons.calculate),
                              label: const Text('模拟'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 结果卡片
                  if (vm.result != null) ...[
                    const SizedBox(height: 16),
                    _buildResultCard(
                        context, theme, settings, dashVm, vm),
                  ],

                  // 已保存
                  if (vm.savedItems.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      '已保存的模拟',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ...vm.savedItems.map((item) => Card(
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text(item.isInstallment
                                ? '${settings.currency}${item.monthlyPayment?.toStringAsFixed(0) ?? "0"}/月 × ${item.installmentPeriods}期'
                                : '${settings.currency}${item.totalCost.toStringAsFixed(0)}/年 周期性'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  vm.deleteSavedItem(item.id),
                            ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    ThemeData theme,
    SettingsViewModel settings,
    SleepCostDashboardViewModel dashVm,
    AffordabilitySimulatorViewModel vm,
  ) {
    final result = vm.result!;
    final hasIncome = settings.hasIncome;

    // 幸福感影响
    double? currentRatio;
    double? projectedRatio;
    HappinessLevel? currentLevel;
    HappinessLevel? projectedLevel;
    int? currentScore;
    int? projectedScore;

    if (hasIncome) {
      currentRatio = settings.costRatio(result.currentDailyCost);
      projectedRatio = settings.costRatio(result.projectedDailyCost);
      currentLevel = SettingsViewModel.happinessFromRatio(currentRatio);
      projectedLevel = SettingsViewModel.happinessFromRatio(projectedRatio);
      currentScore = SettingsViewModel.happinessScore(currentRatio);
      projectedScore = SettingsViewModel.happinessScore(projectedRatio);
    }

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('模拟结果',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            // 每日成本对比
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCostColumn(
                  theme,
                  label: '当前',
                  cost:
                      '${settings.currency}${result.currentDailyCost.toStringAsFixed(2)}',
                  sub: '/天',
                ),
                Icon(Icons.arrow_forward,
                    color: theme.colorScheme.primary),
                _buildCostColumn(
                  theme,
                  label: '购买后',
                  cost:
                      '${settings.currency}${result.projectedDailyCost.toStringAsFixed(2)}',
                  sub: '/天',
                  highlight: result.percentageIncrease > 15,
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (result.dailyIncrease > 0)
              Text(
                '每天多花 ${settings.currency}${result.dailyIncrease.toStringAsFixed(2)}（+${result.percentageIncrease.toStringAsFixed(1)}%）',
                style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer),
              ),

            const SizedBox(height: 12),

            // 建议
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result.recommendation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            // 幸福感影响
            if (hasIncome) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              const Text('幸福感影响',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              // 分数对比
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreColumn(
                    theme,
                    label: '当前',
                    score: currentScore!,
                    level: currentLevel!,
                    ratio: currentRatio!,
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_forward,
                          color: theme.colorScheme.primary, size: 20),
                      Text(
                        '${projectedScore! - currentScore!}分',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: projectedScore! < currentScore!
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  _buildScoreColumn(
                    theme,
                    label: '购买后',
                    score: projectedScore!,
                    level: projectedLevel!,
                    ratio: projectedRatio!,
                  ),
                ],
              ),

              if (currentLevel != projectedLevel) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: projectedLevel!.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: projectedLevel.color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18, color: projectedLevel.color),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '幸福感从「${currentLevel!.label}」降至「${projectedLevel.label}」',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: projectedLevel.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 分项影响（仅周期性支出）
              if (!vm.isInstallment) ...[
                const SizedBox(height: 12),
                _buildCategoryImpact(
                    theme, settings, dashVm, vm.monthlyPayment),
              ],
            ],

            const SizedBox(height: 12),

            // 保存按钮
            TextButton.icon(
              onPressed: vm.saveCurrentItem,
              icon: const Icon(Icons.bookmark_border),
              label: const Text('保存此模拟'),
            ),
          ],
        ),
      ),
    );
  }

  /// 分项健康度影响
  Widget _buildCategoryImpact(
    ThemeData theme,
    SettingsViewModel settings,
    SleepCostDashboardViewModel dashVm,
    double addedMonthly,
  ) {
    final group = _simCategory.group;
    final income = settings.monthlyIncome;
    final currentDaily = dashVm.summary.groupDailyCosts[group] ?? 0;
    final currentMonthly = SettingsViewModel.dailyToMonthly(currentDaily);
    final projectedMonthly = currentMonthly + addedMonthly;
    final currentRatio = currentMonthly / income;
    final projectedRatio = projectedMonthly / income;

    // 参考基准
    const benchmarks = {
      CostCategoryGroup.housing: (0.30, '居住'),
      CostCategoryGroup.transport: (0.10, '交通'),
      CostCategoryGroup.living: (0.15, '生活'),
      CostCategoryGroup.communication: (0.05, '通信'),
      CostCategoryGroup.digitalSubscription: (0.05, '数字订阅'),
      CostCategoryGroup.healthCare: (0.08, '医疗健康'),
      CostCategoryGroup.education: (0.08, '教育'),
      CostCategoryGroup.other: (0.05, '其他'),
    };
    final benchmark = benchmarks[group];
    if (benchmark == null) return const SizedBox.shrink();
    final (healthyMax, _) = benchmark;

    final wasHealthy = currentRatio <= healthyMax;
    final willBeHealthy = projectedRatio <= healthyMax;

    final statusColor =
        willBeHealthy ? Colors.green : Colors.orange;
    final statusText = willBeHealthy ? '仍在健康范围' : '将超出建议值';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(group.icon, size: 16, color: group.color),
              const SizedBox(width: 6),
              Text('「${group.displayName}」分项影响',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${(currentRatio * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: wasHealthy ? Colors.green : Colors.orange),
              ),
              const Text(' → ', style: TextStyle(fontSize: 13)),
              Text(
                '${(projectedRatio * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: statusColor),
              ),
              const SizedBox(width: 8),
              Text('（建议 ≤${(healthyMax * 100).toInt()}%）',
                  style: TextStyle(
                      fontSize: 11, color: theme.colorScheme.outline)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                willBeHealthy ? Icons.check_circle : Icons.warning_amber,
                size: 14,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Text(statusText,
                  style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500)),
              if (!wasHealthy && !willBeHealthy)
                Text('（当前已超标）',
                    style: TextStyle(
                        fontSize: 11, color: theme.colorScheme.outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostColumn(
    ThemeData theme, {
    required String label,
    required String cost,
    required String sub,
    bool highlight = false,
  }) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: theme.colorScheme.onSecondaryContainer
                    .withValues(alpha: 0.6))),
        Text(
          cost,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.red : null,
          ),
        ),
        Text(sub),
      ],
    );
  }

  Widget _buildScoreColumn(
    ThemeData theme, {
    required String label,
    required int score,
    required HappinessLevel level,
    required double ratio,
  }) {
    final sColor = SettingsViewModel.scoreColor(score);
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSecondaryContainer
                    .withValues(alpha: 0.6))),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: sColor),
        ),
        Text(level.emoji, style: const TextStyle(fontSize: 18)),
        Text(level.label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: level.color)),
        Text('占比 ${(ratio * 100).toStringAsFixed(0)}%',
            style: TextStyle(
                fontSize: 10, color: theme.colorScheme.outline)),
      ],
    );
  }
}
