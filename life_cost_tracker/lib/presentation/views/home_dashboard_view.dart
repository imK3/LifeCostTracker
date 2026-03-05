// home_dashboard_view.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 主页仪表板视图
// Home Dashboard View

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_dashboard_view_model.dart';
import '../viewmodels/all_items_list_view_model.dart';
import 'add_new_item_sheet.dart';
import 'item_detail_view.dart';

/// Home Dashboard View - main screen of the app
/// 主页仪表板视图 - 应用的主屏幕
class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  @override
  void initState() {
    super.initState();
    // Load data when widget initializes
    // 小部件初始化时加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeDashboardViewModel>().loadDashboardData();
      context.read<AllItemsListViewModel>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeCostTracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Filter button
          // 过滤按钮
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
        ],
      ),
      body: Consumer2<HomeDashboardViewModel, AllItemsListViewModel>(
        builder: (context, dashboardVM, listVM, child) {
          if (dashboardVM.isLoading || listVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dashboardVM.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${dashboardVM.errorMessage}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Top Hero Section
              // 顶部 Hero 区域
              SliverToBoxAdapter(
                child: _buildTopHeroSection(context, dashboardVM),
              ),
              
              // Sorting Toggle
              // 排序切换
              SliverToBoxAdapter(
                child: _buildSortingToggle(context, listVM),
              ),
              
              // All Items List
              // 所有物品列表
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < listVM.displayItems.length) {
                        return _buildItemCard(context, listVM.displayItems[index]);
                      }
                      return null;
                    },
                    childCount: listVM.displayItems.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddNewItemSheet(),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build top hero section with 3 key metrics
  /// 构建顶部 Hero 区域，显示3个关键指标
  Widget _buildTopHeroSection(BuildContext context, HomeDashboardViewModel vm) {
    final averageDailyCost = vm.averageDailyCost ?? 0.0;
    final dailyCostBreakdown = vm.dailyCostBreakdown;
    final subscriptionDailyCost = dailyCostBreakdown?.subscriptionDailyCost ?? 0.0;
    final totalItems = context.read<AllItemsListViewModel>().displayItems.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left: Average Daily Cost
          // 左侧：平均每日成本
          _buildMetricCard(
            context,
            title: '平均每日成本',
            value: '${averageDailyCost.toStringAsFixed(0)}元/天',
            valueStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Middle: Monthly Subscription Cost
          // 中间：月度订阅支出
          _buildMetricCard(
            context,
            title: '月度订阅支出',
            value: '${(subscriptionDailyCost * 30).toStringAsFixed(0)}元/月',
            subtitle: '${subscriptionDailyCost.toStringAsFixed(1)}元/天',
          ),
          
          // Right: Total Items
          // 右侧：全部项目
          _buildMetricCard(
            context,
            title: '全部项目',
            value: '${totalItems}个项目',
          ),
        ],
      ),
    );
  }

  /// Build metric card
  /// 构建指标卡片
  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    Widget? subtitle,
    TextStyle? valueStyle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: valueStyle ??
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          subtitle!,
        ],
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build sorting toggle (segmented control)
  /// 构建排序切换（分段控制器）
  Widget _buildSortingToggle(BuildContext context, AllItemsListViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SegmentedButton<ItemSortOption>(
        segments: const [
          ButtonSegment(
            value: ItemSortOption.costEffectiveness,
            label: Text('按性价比'),
            icon: Icon(Icons.stars),
          ),
          ButtonSegment(
            value: ItemSortOption.dailyCost,
            label: Text('按日耗'),
            icon: Icon(Icons.trending_down),
          ),
          ButtonSegment(
            value: ItemSortOption.category,
            label: Text('按分类'),
            icon: Icon(Icons.category),
          ),
        ],
        selected: {vm.sortOption},
        onSelectionChanged: (Set<ItemSortOption> newSelection) {
          vm.setSortOption(newSelection.first);
        },
      ),
    );
  }

  /// Build item card
  /// 构建物品卡片
  Widget _buildItemCard(BuildContext context, dynamic item) {
    // Note: This is a placeholder - we need to use the actual DisplayItem type
    // 注：这是占位符 - 我们需要使用实际的 DisplayItem 类型
    // For now, let's assume item has these properties
    // 现在，让我们假设 item 有这些属性
    
    final String name = item.name ?? 'Unknown';
    final String? category = item.category;
    final double? dailyCost = item.dailyCost;
    final String? type = item.type;
    final String? tierLabel = _getTierLabel(item.tier);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category != null)
              Chip(
                label: Text(category),
                visualDensity: VisualDensity.compact,
              ),
            if (tierLabel != null)
              Chip(
                label: Text(tierLabel),
                visualDensity: VisualDensity.compact,
                backgroundColor: _getTierColor(item.tier, context).withOpacity(0.2),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: dailyCost != null
            ? Text('日耗: ¥${dailyCost.toStringAsFixed(1)}')
            : null,
        trailing: dailyCost != null
            ? Text(
                '¥${dailyCost.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              )
            : null,
        onTap: () {
          // Navigate to item detail
          // 导航到物品详情
          // For now, show a dialog
          // 现在，显示一个对话框
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(name),
              content: Text('Item detail view coming soon'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('关闭'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Get tier label
  /// 获取等级标签
  String? _getTierLabel(dynamic tier) {
    if (tier == null) return null;
    final tierName = tier.toString().split('.').last;
    switch (tierName) {
      case 'divine':
        return '神仙性价比';
      case 'excellent':
        return '超值';
      case 'good':
        return '优秀';
      case 'fair':
        return '一般';
      case 'poor':
        return '不值得';
      default:
        return null;
    }
  }

  /// Get tier color
  /// 获取等级颜色
  Color _getTierColor(dynamic tier, BuildContext context) {
    if (tier == null) return Colors.grey;
    final tierName = tier.toString().split('.').last;
    switch (tierName) {
      case 'divine':
        return Colors.green;
      case 'excellent':
        return Colors.blue;
      case 'good':
        return Colors.orange;
      case 'fair':
        return Colors.orange.shade300;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Show filter sheet
  /// 显示过滤表单
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<AllItemsListViewModel>(
          builder: (context, vm, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '筛选物品',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...ItemFilterOption.values.map((option) {
                    return RadioListTile<ItemFilterOption>(
                      title: Text(_getFilterLabel(option)),
                      value: option,
                      groupValue: vm.filterOption,
                      onChanged: (value) {
                        if (value != null) {
                          vm.setFilterOption(value);
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Get filter label
  /// 获取过滤标签
  String _getFilterLabel(ItemFilterOption option) {
    switch (option) {
      case ItemFilterOption.all:
        return '全部';
      case ItemFilterOption.physical:
        return '实物';
      case ItemFilterOption.subscriptions:
        return '订阅';
      case ItemFilterOption.cloudServices:
        return '云服务/工具';
    }
  }
}
