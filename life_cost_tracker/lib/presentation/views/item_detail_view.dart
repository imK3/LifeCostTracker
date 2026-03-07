// item_detail_view.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 物品详情视图
// Item Detail View

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodels/item_detail_view_model.dart';

/// Item Detail View - shows detailed information about an item
/// 物品详情视图 - 显示物品的详细信息
class ItemDetailView extends StatefulWidget {
  /// Item ID
  /// 物品 ID
  final String itemId;

  /// Item type
  /// 物品类型
  final String itemType;

  const ItemDetailView({
    super.key,
    required this.itemId,
    required this.itemType,
  });

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  @override
  void initState() {
    super.initState();
    // Load item data when widget initializes
    // 小部件初始化时加载物品数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ItemDetailViewModel>()
          .loadItem(widget.itemId, widget.itemType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDetailViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('物品详情'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${vm.errorMessage}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          );
        }

        final item = vm.item;
        if (item == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('物品详情'),
            ),
            body: const Center(child: Text('物品未找到')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Navigate to edit screen
                  // TODO：导航到编辑屏幕
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('编辑功能即将到来')),
                  );
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              // Hero Section
              // Hero 区域
              SliverToBoxAdapter(
                child: _buildHeroSection(context, item),
              ),

              // History & Stats Section
              // 历史和统计区域
              SliverToBoxAdapter(
                child: _buildHistoryAndStatsSection(context, item),
              ),

              // Actions Section
              // 操作区域
              SliverToBoxAdapter(
                child: _buildActionsSection(context, item, vm),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build hero section with key item information
  /// 构建顶部 Hero 区域，显示关键物品信息
  Widget _buildHeroSection(BuildContext context, dynamic item) {
    final name = item.name ?? 'Unknown';
    final dailyCost = item.dailyCost ?? 0.0;
    final totalCost = item.totalCost ?? 0.0;
    final category = item.category;
    final isOwned = item.isOwned ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Item name
          // 物品名称
          Text(
            name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Daily cost (large, prominent)
          // 每日成本（大号，突出）
          Text(
            '¥${dailyCost.toStringAsFixed(1)}/天',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Total cost + usage info
          // 总成本 + 使用信息
          Text(
            '¥${totalCost.toStringAsFixed(0)} | ${isOwned ? "已拥有" : "愿望清单"}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          // Category pill (if available)
          // 分类标签（如果有）
          if (category != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Chip(
                label: Text(category),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build history and statistics section
  /// 构建历史和统计区域
  Widget _buildHistoryAndStatsSection(BuildContext context, dynamic item) {
    // TODO: Implement charts and statistics
    // TODO：实现图表和统计
    final daysUsed = item.daysUsed ?? 0;
    final dailyCost = item.dailyCost ?? 0.0;
    final totalDailyCost = daysUsed * dailyCost;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '历史和统计',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Usage statistics
          // 使用统计
          _buildStatCard(
            context,
            title: '使用统计',
            items: [
              StatItem(
                label: '已使用天数',
                value: '$daysUsed 天',
              ),
              StatItem(
                label: '累计每日成本',
                value: '¥${totalDailyCost.toStringAsFixed(1)}',
              ),
              StatItem(
                label: '当前日耗',
                value: '¥${dailyCost.toStringAsFixed(1)}/天',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart implementation
          // 图表实现
          Container(
            height: 200,
            padding: const EdgeInsets.only(right: 16, left: 8, top: 16, bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: dailyCost > 0 ? dailyCost : 1,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const Text('开始');
                        if (value == daysUsed.toDouble()) return const Text('今天');
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0),
                      FlSpot(daysUsed.toDouble(), totalDailyCost),
                    ],
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build stat card
  /// 构建统计卡片
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required List<StatItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.label),
                  Text(
                    item.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Build actions section
  /// 构建操作区域
  Widget _buildActionsSection(
      BuildContext context, dynamic item, ItemDetailViewModel vm) {
    final isOwned = item.isOwned ?? false;
    final itemType = item.type ?? 'unknown';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '操作',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Toggle owned/wishlist
          // 切换已拥有/愿望清单
          ElevatedButton.icon(
            onPressed: () {
              vm.toggleItemOwnership('', '');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isOwned ? '已移至愿望清单' : '已标记为已拥有'),
                ),
              );
            },
            icon: Icon(isOwned ? Icons.favorite_border : Icons.favorite),
            label: Text(isOwned ? '移至愿望清单' : '标记为已拥有'),
          ),

          const SizedBox(height: 12),

          // Mark as sold/gone (for owned items)
          // 标记为已售出/消失（对已拥有物品）
          if (isOwned)
            ElevatedButton.icon(
              onPressed: () {
                vm.markItemAsSold('', '');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已标记为已售出')),
                );
              },
              icon: const Icon(Icons.sell),
              label: const Text('标记为已售出'),
            ),

          const SizedBox(height: 24),

          // Delete button (red)
          // 删除按钮（红色）
          OutlinedButton.icon(
            onPressed: () {
              _showDeleteConfirmation(context, item, vm);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  /// 显示删除确认对话框
  void _showDeleteConfirmation(
      BuildContext context, dynamic item, ItemDetailViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${item.name ?? "此物品"}"吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              vm.deleteItem();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('物品已删除')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    return;
  }
}

/// Stat item
/// 统计项
class StatItem {
  final String label;
  final String value;

  StatItem({
    required this.label,
    required this.value,
  });
}
