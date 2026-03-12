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

                // Monthly payment tracking card
                if (vm.summary.totalItemCount > 0)
                  SliverToBoxAdapter(
                    child: _buildMonthlyPaymentCard(context, vm, settings),
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

                // Fixed Living Costs Section
                if (vm.summary.unpaidFixedLivingItems.isNotEmpty)
                  _buildCostSection(
                    context,
                    title: '固定生活成本',
                    subtitle:
                        '${settings.currency}${vm.fixedLivingDisplayCost.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                    color: const Color(0xFF4CAF50),
                    items: vm.summary.unpaidFixedLivingItems,
                    vm: vm,
                    settings: settings,
                  ),

                // Subscription Costs Section
                if (vm.summary.unpaidSubscriptionItems.isNotEmpty)
                  _buildCostSection(
                    context,
                    title: '订阅费用',
                    subtitle:
                        '${settings.currency}${vm.subscriptionDisplayCost.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                    color: const Color(0xFF2196F3),
                    items: vm.summary.unpaidSubscriptionItems,
                    vm: vm,
                    settings: settings,
                  ),

                // Installment Plans Section
                if (vm.summary.installmentItems.isNotEmpty)
                  _buildInstallmentSection(context, vm, settings),

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

                // Paid items section
                if (vm.summary.paidFixedLivingItems.isNotEmpty ||
                    vm.summary.paidSubscriptionItems.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 18, color: theme.colorScheme.outline),
                          const SizedBox(width: 6),
                          Text(
                            '本期已支付',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (vm.summary.paidFixedLivingItems.isNotEmpty ||
                    vm.summary.paidSubscriptionItems.isNotEmpty)
                  _buildPaidItemsList(
                    context,
                    [
                      ...vm.summary.paidFixedLivingItems,
                      ...vm.summary.paidSubscriptionItems,
                    ],
                    vm,
                    settings,
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
          // Three mini stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniStat(
                context,
                '固定生活',
                '${settings.currency}${vm.fixedLivingDisplayCost.toStringAsFixed(0)}',
                const Color(0xFF4CAF50),
              ),
              _buildMiniStat(
                context,
                '订阅',
                '${settings.currency}${vm.subscriptionDisplayCost.toStringAsFixed(0)}',
                const Color(0xFF2196F3),
              ),
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

  Widget _buildMonthlyPaymentCard(
    BuildContext context,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    final theme = Theme.of(context);
    final summary = vm.summary;
    final paid = summary.paidAmount;
    final unpaid = summary.unpaidAmount;
    final progress = summary.paymentProgress;
    final cycle = vm.paymentCycle;

    // Title based on cycle
    String title;
    switch (cycle) {
      case DisplayCycle.daily:
        title = '今日缴费';
      case DisplayCycle.monthly:
        title = '${DateTime.now().month}月缴费进度';
      case DisplayCycle.yearly:
        title = '${DateTime.now().year}年缴费进度';
    }

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
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${summary.paidItems.length}/${summary.allRecurringItems.length} 项已付',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Cycle selector
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<DisplayCycle>(
              segments: const [
                ButtonSegment(
                  value: DisplayCycle.daily,
                  label: Text('每日', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: DisplayCycle.monthly,
                  label: Text('每月', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: DisplayCycle.yearly,
                  label: Text('每年', style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: {cycle},
              onSelectionChanged: (selected) {
                vm.setPaymentCycle(selected.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
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
                      '已付 ${settings.currency}${paid.toStringAsFixed(0)}',
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
                      '待付 ${settings.currency}${unpaid.toStringAsFixed(0)}',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            if (vm.summary.fixedLivingPercentage > 0)
              PieChartSectionData(
                value: vm.summary.fixedLivingPercentage * 100,
                title:
                    '${(vm.summary.fixedLivingPercentage * 100).toStringAsFixed(0)}%',
                color: const Color(0xFF4CAF50),
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            if (vm.summary.subscriptionPercentage > 0)
              PieChartSectionData(
                value: vm.summary.subscriptionPercentage * 100,
                title:
                    '${(vm.summary.subscriptionPercentage * 100).toStringAsFixed(0)}%',
                color: const Color(0xFF2196F3),
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            if (vm.summary.installmentPercentage > 0)
              PieChartSectionData(
                value: vm.summary.installmentPercentage * 100,
                title:
                    '${(vm.summary.installmentPercentage * 100).toStringAsFixed(0)}%',
                color: const Color(0xFFFF9800),
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverList _buildCostSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required List<RecurringCost> items,
    required SleepCostDashboardViewModel vm,
    required SettingsViewModel settings,
  }) {
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

          final item = items[index - 1];
          final displayAmount =
              item.dailyCost * vm.displayCycle.daysMultiplier;
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
              onTap: () => _navigateToDetail(context, recurringCost: item),
            ),
          );
        },
        childCount: items.length + 1,
      ),
    );
  }

  SliverList _buildInstallmentSection(
    BuildContext context,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    final items = vm.summary.installmentItems;
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
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('分期承诺',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(
                    '${settings.currency}${vm.installmentDisplayCost.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            );
          }

          final item = items[index - 1];
          final displayAmount =
              item.dailyCost * vm.displayCycle.daysMultiplier;

          return ListTile(
            leading: const Icon(Icons.credit_card,
                color: Color(0xFFFF9800)),
            title: Text(item.name),
            subtitle: Text(
                '${settings.currency}${item.monthlyPayment.toStringAsFixed(0)}/月 · 剩余${item.remainingPeriods}期'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${settings.currency}${displayAmount.toStringAsFixed(2)}/${vm.displayCycle.unitLabel}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF9800)),
                  ),
                ),
              ],
            ),
            onTap: () => _navigateToDetail(context, installmentPlan: item),
          );
        },
        childCount: items.length + 1,
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

  SliverList _buildPaidItemsList(
    BuildContext context,
    List<RecurringCost> items,
    SleepCostDashboardViewModel vm,
    SettingsViewModel settings,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
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
            onTap: () => _navigateToDetail(context, recurringCost: item),
          );
        },
        childCount: items.length,
      ),
    );
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
