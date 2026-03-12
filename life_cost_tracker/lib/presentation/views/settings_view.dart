// settings_view.dart
// LifeCostTracker
// 设置页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/display_cycle.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
