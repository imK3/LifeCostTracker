// home_dashboard_view.dart
// LifeCostTracker
// 睡后成本 Dashboard 主页

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sleep_cost_dashboard_view_model.dart';
import '../viewmodels/cost_item_detail_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/display_cycle.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';
import 'add_cost_item_sheet.dart';
import 'cost_item_detail_view.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepCostDashboardViewModel>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsViewModel>();

    return Scaffold(
      body: Consumer<SleepCostDashboardViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.summary.totalItemCount == 0) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: vm.loadDashboardData,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 60,
                  floating: true,
                  title: const Text('睡后成本'),
                  actions: [
                    // Display cycle toggle
                    PopupMenuButton<DisplayCycle>(
                      icon: const Icon(Icons.tune),
                      onSelected: (cycle) {
                        vm.setDisplayCycle(cycle);
                      },
                      itemBuilder: (context) => DisplayCycle.values
                          .map((c) => PopupMenuItem(
                                value: c,
                                child: Row(
                                  children: [
                                    if (c == vm.displayCycle)
                                      Icon(Icons.check,
                                          size: 18,
                                          color: theme.colorScheme.primary),
                                    if (c == vm.displayCycle)
                                      const SizedBox(width: 8),
                                    Text('按${c.displayName}'),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),

                // Hero Section - 大数字
                SliverToBoxAdapter(
                  child: _buildHeroSection(context, vm, settings),
                ),

                // Payment tracking card (by due date)
                if (vm.summary.totalItemCount > 0)
                  SliverToBoxAdapter(
                    child: _buildPaymentTrackingCard(context, vm, settings),
                  ),

                // Pie Chart
                if (vm.summary.totalDailyCost > 0)
                  SliverToBoxAdapter(
                    child: _buildPieChart(context, vm),
                  ),

                // Category breakdown header
                if (vm.summary.totalItemCount > 0)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '成本明细',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Overdue items (recurring + installment)
                if (vm.summary.overdueItems.isNotEmpty ||
                    vm.summary.installmentOverdueItems.isNotEmpty)
                  _buildUnifiedCostSection(
                    context,
                    title: '已逾期',
                    subtitle: '${settings.currency}${(vm.summary.overdueAmount + vm.summary.installmentOverdueAmount).toStringAsFixed(0)}',
                    color: Colors.red,
                    recurringItems: vm.summary.overdueItems,
                    installmentItems: vm.summary.installmentOverdueItems,
                    vm: vm,
                    settings: settings,
                  ),

                // Due this month (recurring + installment)
                if (vm.summary.dueThisMonth.isNotEmpty ||
                    vm.summary.installmentDueThisMonth.isNotEmpty)
                  _buildUnifiedCostSection(
                    context,
                    title: '本月待缴',
                    subtitle: '${settings.currency}${(vm.summary.dueThisMonthAmount + vm.summary.installmentDueThisMonthAmount).toStringAsFixed(0)}',
                    color: Colors.orange,
                    recurringItems: vm.summary.dueThisMonth,
                    installmentItems: vm.summary.installmentDueThisMonth,
                    vm: vm,
                    settings: settings,
                  ),

                // Paid items section (recurring + installment)
                if (vm.summary.paidItems.isNotEmpty ||
                    vm.summary.installmentMonthlyPaid.isNotEmpty)
                  _buildUnifiedPaidSection(
                    context, vm, settings,
                  ),

                // Empty state
                if (vm.summary.totalItemCount == 0)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline,
                              size: 64,
                              color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text(
                            '还没有成本项',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '点击右下角添加你的第一个成本项',
                            style: TextStyle(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCostSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('添加'),
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    final theme = Theme.of(context);
    final cycle = vm.displayCycle;

    String headline;
    switch (cycle) {
      case DisplayCycle.daily:
        headline = '今天你一睁眼就欠了';
      case DisplayCycle.monthly:
        headline = '这个月你要付出';
      case DisplayCycle.quarterly:
        headline = '这个季度你要付出';
      case DisplayCycle.yearly:
        headline = '今年你的固定支出是';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            headline,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${settings.currency}${vm.displayCost.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '每${cycle.unitLabel}',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          // Top category groups + installment
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              ...vm.summary.activeGroups.take(3).map((group) =>
                _buildMiniStat(
                  context,
                  group.displayName,
                  '${settings.currency}${vm.groupDisplayCost(group).toStringAsFixed(0)}',
                  group.color,
                ),
              ),
              if (vm.installmentDisplayCost > 0)
                _buildMiniStat(
                  context,
                  '分期',
                  '${settings.currency}${vm.installmentDisplayCost.toStringAsFixed(0)}',
                  const Color(0xFFFF9800),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTrackingCard(
    BuildContext context,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    final theme = Theme.of(context);
    final summary = vm.summary;
    final now = DateTime.now();
    final paid = summary.paidAmount;
    final unpaid = summary.totalDueAmount - paid;
    final progress = summary.paymentProgress;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                '${now.month}月缴费进度',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${summary.monthlyPaidCount}/${summary.monthlyTrackableCount} 项已付',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Paid / Unpaid amounts
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '已缴 ${settings.currency}${paid.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: unpaid > 0
                            ? Colors.orange.shade600
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '待缴 ${settings.currency}${unpaid.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: unpaid > 0
                            ? Colors.orange.shade700
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (summary.overdueCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 16, color: Colors.red.shade600),
                const SizedBox(width: 4),
                Text(
                  '${summary.overdueCount} 项已逾期',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    SleepCostDashboardViewModel vm,
  ) {
    final sections = <PieChartSectionData>[];

    // Add sections for each active category group
    for (final group in vm.summary.activeGroups) {
      final pct = vm.summary.groupPercentage(group);
      if (pct > 0) {
        sections.add(PieChartSectionData(
          value: pct * 100,
          title: '${(pct * 100).toStringAsFixed(0)}%',
          color: group.color,
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
      }
    }

    // Add installment section
    if (vm.summary.installmentPercentage > 0) {
      sections.add(PieChartSectionData(
        value: vm.summary.installmentPercentage * 100,
        title:
            '${(vm.summary.installmentPercentage * 100).toStringAsFixed(0)}%',
        color: const Color(0xFFFF9800),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      height: 220,
      child: Row(
        children: [
          // Pie chart
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 35,
                sections: sections,
              ),
            ),
          ),
          // Legend
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...vm.summary.activeGroups.map((group) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: group.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          group.displayName,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
                if (vm.summary.installmentPercentage > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('分期', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddCostItemSheet(),
    ).then((_) {
      context.read<SleepCostDashboardViewModel>().loadDashboardData();
    });
  }


  Future<void> _markAsPaid(BuildContext context, RecurringCost item) async {
    final detailVm = context.read<CostItemDetailViewModel>();
    final paid = item.payAndAdvance();
    await detailVm.updateRecurringCost(paid);
    if (context.mounted) {
      context.read<SleepCostDashboardViewModel>().loadDashboardData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('「${item.name}」已标记为已支付'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _markInstallmentAsPaid(
      BuildContext context, InstallmentPlan item) async {
    final detailVm = context.read<CostItemDetailViewModel>();
    final paid = item.payAndAdvance();
    await detailVm.updateInstallmentPlan(paid);
    if (context.mounted) {
      context.read<SleepCostDashboardViewModel>().loadDashboardData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('「${item.name}」已标记为已支付（${item.paidPeriods + 1}/${item.totalPeriods}期）'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// 统一展示区域：周期性 + 分期混合
  SliverList _buildUnifiedCostSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required List<RecurringCost> recurringItems,
    required List<InstallmentPlan> installmentItems,
    required SleepCostDashboardViewModel vm,
    required SettingsViewModel settings,
  }) {
    final totalCount = recurringItems.length + installmentItems.length;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            );
          }

          final itemIndex = index - 1;

          // 先显示周期性项，再显示分期项
          if (itemIndex < recurringItems.length) {
            final item = recurringItems[itemIndex];
            final displayAmount =
                item.dailyCost * vm.displayCycle.actualDays;
            final dueText = item.isOverdue
                ? '已逾期'
                : item.daysUntilDue == 0
                    ? '今天到期'
                    : '${item.daysUntilDue}天后到期';

            return Dismissible(
              key: Key('pay_${item.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 4),
                    Text('标记已付',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                await _markAsPaid(context, item);
                return false;
              },
              child: ListTile(
                leading: Icon(item.category.icon, color: color),
                title: Text(item.name),
                subtitle: Text(
                    '${settings.currency}${item.amount.toStringAsFixed(0)}/${item.billingCycle.displayName} · $dueText'),
                trailing: Text(
                  '${settings.currency}${displayAmount.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () =>
                    _navigateToDetail(context, recurringCost: item),
              ),
            );
          } else {
            // 分期项
            final item = installmentItems[itemIndex - recurringItems.length];
            final displayAmount =
                item.dailyCost * vm.displayCycle.actualDays;
            final dueText = item.isOverdue
                ? '已逾期'
                : item.daysUntilDue == 0
                    ? '今天到期'
                    : '${item.daysUntilDue}天后到期';

            return Dismissible(
              key: Key('pay_inst_${item.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 4),
                    Text('标记已付',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                await _markInstallmentAsPaid(context, item);
                return false;
              },
              child: ListTile(
                leading: Icon(Icons.credit_card, color: color),
                title: Text(item.name),
                subtitle: Text(
                    '${settings.currency}${item.monthlyPayment.toStringAsFixed(0)}/月 · ${item.paidPeriods}/${item.totalPeriods}期 · $dueText'),
                trailing: Text(
                  '${settings.currency}${displayAmount.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () =>
                    _navigateToDetail(context, installmentPlan: item),
              ),
            );
          }
        },
        childCount: totalCount + 1,
      ),
    );
  }

  /// 统一已缴清区域
  SliverList _buildUnifiedPaidSection(
    BuildContext context,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    final theme = Theme.of(context);
    final recurringPaid = vm.summary.paidItems;
    final installmentPaid = vm.summary.installmentMonthlyPaid;
    final totalPaidAmount =
        recurringPaid.fold<double>(0, (s, i) => s + i.paymentAmount) +
        installmentPaid.fold<double>(0, (s, i) => s + i.monthlyPayment);
    final totalCount = recurringPaid.length + installmentPaid.length;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 18, color: theme.colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    '已缴清',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${settings.currency}${totalPaidAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          final itemIndex = index - 1;
          if (itemIndex < recurringPaid.length) {
            final item = recurringPaid[itemIndex];
            return ListTile(
              leading: Icon(item.category.icon,
                  color: Colors.grey.shade400),
              title: Text(
                item.name,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                '${settings.currency}${item.amount.toStringAsFixed(0)}/${item.billingCycle.displayName} · 下次: ${item.nextDueDate.month}/${item.nextDueDate.day}',
                style: TextStyle(color: Colors.grey.shade400),
              ),
              trailing: Icon(Icons.check_circle,
                  color: Colors.green.shade300, size: 20),
              onTap: () =>
                  _navigateToDetail(context, recurringCost: item),
            );
          } else {
            final item = installmentPaid[itemIndex - recurringPaid.length];
            return ListTile(
              leading: Icon(Icons.credit_card,
                  color: Colors.grey.shade400),
              title: Text(
                item.name,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                '${settings.currency}${item.monthlyPayment.toStringAsFixed(0)}/月 · ${item.paidPeriods}/${item.totalPeriods}期 · 下次: ${item.nextDueDate.month}/${item.nextDueDate.day}',
                style: TextStyle(color: Colors.grey.shade400),
              ),
              trailing: Icon(Icons.check_circle,
                  color: Colors.green.shade300, size: 20),
              onTap: () =>
                  _navigateToDetail(context, installmentPlan: item),
            );
          }
        },
        childCount: totalCount + 1,
      ),
    );
  }

  void _navigateToDetail(
    BuildContext context, {
    RecurringCost? recurringCost,
    InstallmentPlan? installmentPlan,
  }) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => CostItemDetailView(
        recurringCost: recurringCost,
        installmentPlan: installmentPlan,
      ),
    ))
        .then((_) {
      context.read<SleepCostDashboardViewModel>().loadDashboardData();
    });
  }
}
