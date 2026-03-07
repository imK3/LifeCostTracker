// reports_view.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 报表视图
// Reports View

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodels/reports_view_model.dart';

/// Reports View - shows monthly and daily cost reports
/// 报表视图 - 显示月度和每日成本报表
class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsViewModel>().loadAllReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ReportsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${vm.errorMessage}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadAllReports(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          final report = vm.monthlyReport;
          final trend = vm.dailyCostTrend;

          return CustomScrollView(
            slivers: [
              // Month selector
              // 月份选择器
              SliverToBoxAdapter(
                child: _buildMonthSelector(context, vm),
              ),

              // Monthly summary cards
              // 月度汇总卡片
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildSummaryCard(
                      context,
                      title: '月度总支出',
                      value: '¥${report?.totalExpenses.toStringAsFixed(0) ?? "0"}',
                      icon: Icons.payments,
                      color: Colors.orange,
                    ),
                    _buildSummaryCard(
                      context,
                      title: '平均每日成本',
                      value: '¥${report?.averageDailyCost?.toStringAsFixed(1) ?? "0"}/天',
                      icon: Icons.calendar_today,
                      color: Colors.green,
                    ),
                    _buildSummaryCard(
                      context,
                      title: '订阅总支出',
                      value: '¥${report?.totalSubscriptions.toStringAsFixed(0) ?? "0"}',
                      icon: Icons.subscriptions,
                      color: Colors.blue,
                    ),
                    _buildSummaryCard(
                      context,
                      title: '总花费',
                      value: '¥${report?.totalSpending.toStringAsFixed(0) ?? "0"}',
                      icon: Icons.account_balance_wallet,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),

              // Daily cost trend chart
              // 每日成本趋势图
              if (trend != null && trend.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '每日成本趋势',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTitlesWidget: (value, meta) {
                                if (value < 0 || value >= trend.length) return const Text('');
                                final date = trend[value.toInt()].date;
                                return Text('${date.day}日');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: trend.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.dailyCost);
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Category breakdown
              // 分类明细
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    '支出分类',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Placeholder categories
                      // 临时分类数据
                      final categories = [
                        {'name': '数码电子', 'amount': 1200, 'color': Colors.blue},
                        {'name': '游戏娱乐', 'amount': 800, 'color': Colors.purple},
                        {'name': '生活消费', 'amount': 600, 'color': Colors.orange},
                        {'name': '订阅服务', 'amount': 300, 'color': Colors.green},
                        {'name': '其他', 'amount': 100, 'color': Colors.grey},
                      ];
                      final category = categories[index];
                      return _buildCategoryItem(
                        context,
                        name: category['name'] as String,
                        amount: category['amount'] as int,
                        color: category['color'] as Color,
                      );
                    },
                    childCount: 5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build month selector
  /// 构建月份选择器
  Widget _buildMonthSelector(BuildContext context, ReportsViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => vm.previousMonth(),
          ),
          Text(
            DateFormat.yMMM('zh_CN').format(vm.selectedMonth),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => vm.nextMonth(),
          ),
        ],
      ),
    );
  }

  /// Build summary card
  /// 构建汇总卡片
  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Build category item
  /// 构建分类项
  Widget _buildCategoryItem(
    BuildContext context, {
    required String name,
    required int amount,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Text(name),
            ],
          ),
          Text(
            '¥$amount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
