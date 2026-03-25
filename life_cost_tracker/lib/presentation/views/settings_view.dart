// settings_view.dart
// LifeCostTracker
// 设置页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/display_cycle.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _showIncomeDialog(BuildContext context, SettingsViewModel vm) {
    final controller = TextEditingController(
      text: vm.monthlyIncome > 0 ? vm.monthlyIncome.toStringAsFixed(0) : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('设置月收入'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '税后月收入',
            prefixText: '¥ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(
                      controller.text.replaceAll(',', '.')) ?? 0;
              vm.setMonthlyIncome(value);
              Navigator.of(ctx).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, vm, child) {
          return ListView(
            children: [
              // Display section
              const _SectionHeader(title: '展示设置'),

              ListTile(
                leading: const Icon(Icons.calendar_view_day),
                title: const Text('默认展示周期'),
                subtitle: Text('按${vm.displayCycle.displayName}查看成本'),
                trailing: DropdownButton<DisplayCycle>(
                  value: vm.displayCycle,
                  underline: const SizedBox(),
                  items: DisplayCycle.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.displayName),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) vm.setDisplayCycle(v);
                  },
                ),
              ),

              ListTile(
                leading: const Icon(Icons.currency_yuan),
                title: const Text('货币符号'),
                subtitle: Text(vm.currency),
                trailing: DropdownButton<String>(
                  value: vm.currency,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: '¥', child: Text('¥ 人民币')),
                    DropdownMenuItem(value: '\$', child: Text('\$ 美元')),
                    DropdownMenuItem(value: '€', child: Text('€ 欧元')),
                  ],
                  onChanged: (v) {
                    if (v != null) vm.setCurrency(v);
                  },
                ),
              ),

              const Divider(),

              const _SectionHeader(title: '收入设置'),

              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('税后月收入'),
                subtitle: Text(vm.hasIncome
                    ? '¥${vm.monthlyIncome.toStringAsFixed(0)}'
                    : '未设置'),
                trailing: const Icon(Icons.edit_outlined, size: 20),
                onTap: () => _showIncomeDialog(context, vm),
              ),

              if (vm.hasIncome)
                ListTile(
                  leading: Text(
                    SettingsViewModel.happinessFromRatio(
                            vm.costRatio(0))
                        .emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: const Text('幸福感参考'),
                  subtitle: const Text('≤40% 很好 · ≤55% 从容 · ≤70% 平衡 · >70% 紧张'),
                ),

              const Divider(),

              // App info
              const _SectionHeader(title: '关于'),

              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('LifeCostTracker'),
                subtitle: Text('v2.0.0 · 睡后成本追踪器'),
              ),

              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('开源地址'),
                subtitle: const Text('github.com/imK3/LifeCostTracker'),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
