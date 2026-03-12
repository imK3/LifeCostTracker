// affordability_simulator_view.dart
// LifeCostTracker
// 承担能力模拟器页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/affordability_simulator_view_model.dart';
import '../viewmodels/settings_view_model.dart';

class AffordabilitySimulatorView extends StatefulWidget {
  const AffordabilitySimulatorView({super.key});

  @override
  State<AffordabilitySimulatorView> createState() =>
      _AffordabilitySimulatorViewState();
}

class _AffordabilitySimulatorViewState
    extends State<AffordabilitySimulatorView> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('承担能力模拟'),
      ),
      body: Consumer<AffordabilitySimulatorViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '如果我要买...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '商品名称',
                            hintText: '例如：iPhone 16 Pro',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: vm.setName,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '总价',
                            border: OutlineInputBorder(),
                            prefixText: '¥ ',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              vm.setTotalCost(double.tryParse(v) ?? 0),
                        ),
                        const SizedBox(height: 12),

                        // Installment toggle
                        SwitchListTile(
                          title: const Text('分期付款'),
                          subtitle: const Text('是否打算分期购买'),
                          value: vm.isInstallment,
                          onChanged: vm.setIsInstallment,
                          contentPadding: EdgeInsets.zero,
                        ),

                        if (vm.isInstallment) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: '分期数',
                                    border: OutlineInputBorder(),
                                    suffixText: '期',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => vm.setInstallmentPeriods(
                                      int.tryParse(v) ?? 12),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: '月供',
                                    border: const OutlineInputBorder(),
                                    prefixText: '¥ ',
                                    hintText: vm.monthlyPayment > 0
                                        ? vm.monthlyPayment
                                            .toStringAsFixed(0)
                                        : null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => vm.setMonthlyPayment(
                                      double.tryParse(v) ?? 0),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Simulate button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: vm.name.isNotEmpty && vm.totalCost > 0
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

                // Result card
                if (vm.result != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: theme.colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            '模拟结果',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Before -> After
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('当前',
                                      style: TextStyle(
                                          color: theme.colorScheme
                                              .onSecondaryContainer
                                              .withValues(alpha: 0.6))),
                                  Text(
                                    '${settings.currency}${vm.result!.currentDailyCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('/天'),
                                ],
                              ),
                              Icon(Icons.arrow_forward,
                                  color: theme.colorScheme.primary),
                              Column(
                                children: [
                                  Text('购买后',
                                      style: TextStyle(
                                          color: theme.colorScheme
                                              .onSecondaryContainer
                                              .withValues(alpha: 0.6))),
                                  Text(
                                    '${settings.currency}${vm.result!.projectedDailyCost.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: vm.result!
                                                  .percentageIncrease >
                                              15
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                  const Text('/天'),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Increase info
                          if (vm.result!.dailyIncrease > 0)
                            Text(
                              '每天多花 ${settings.currency}${vm.result!.dailyIncrease.toStringAsFixed(2)}（+${vm.result!.percentageIncrease.toStringAsFixed(1)}%）',
                              style: TextStyle(
                                  color: theme.colorScheme
                                      .onSecondaryContainer),
                            ),

                          const SizedBox(height: 12),

                          // Recommendation
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vm.result!.recommendation,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Save button
                          TextButton.icon(
                            onPressed: vm.saveCurrentItem,
                            icon: const Icon(Icons.bookmark_border),
                            label: const Text('保存此模拟'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Saved items
                if (vm.savedItems.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    '已保存的模拟',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...vm.savedItems.map((item) => Card(
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            item.isInstallment
                                ? '${settings.currency}${item.totalCost.toStringAsFixed(0)} · ${item.installmentPeriods}期 · ${settings.currency}${item.monthlyPayment?.toStringAsFixed(0)}/月'
                                : '${settings.currency}${item.totalCost.toStringAsFixed(0)} 一次性',
                          ),
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
          );
        },
      ),
    );
  }
}
