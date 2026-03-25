// happiness_research_page.dart
// LifeCostTracker
// 幸福感研究说明页

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_view_model.dart';
import '../viewmodels/sleep_cost_dashboard_view_model.dart';
import '../../domain/entities/cost_category.dart';

class HappinessResearchPage extends StatelessWidget {
  const HappinessResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsViewModel>();
    final vm = context.watch<SleepCostDashboardViewModel>();
    final ratio = settings.costRatio(vm.summary.totalDailyCost);
    final level = SettingsViewModel.happinessFromRatio(ratio);
    final score = SettingsViewModel.happinessScore(ratio);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('幸福感与支出'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 当前状态卡片
                  _buildCurrentStatusCard(
                      context, theme, settings, vm, ratio, level, score),
                  const SizedBox(height: 28),

                  // 核心观点
                  _buildSectionTitle(theme, '核心观点'),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    theme,
                    icon: Icons.lightbulb_outline,
                    color: Colors.amber,
                    title: '幸福感的关键不是赚多少',
                    body: '研究表明，收入超过一定阈值后，幸福感提升趋于平缓。'
                        '真正影响幸福感的是「可自由支配的比例」—— 你能不能不计较地喝一杯咖啡、'
                        '看一场电影、给朋友买个小礼物。',
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    theme,
                    icon: Icons.shield_outlined,
                    color: Colors.blue,
                    title: '安全感来自储蓄缓冲',
                    body: '拥有 3-6 个月紧急资金的人，焦虑水平显著低于月光族。'
                        '不是因为他们更富有，而是因为「知道自己能扛住意外」本身就是一种安心。',
                  ),
                  const SizedBox(height: 28),

                  // 50/30/20 法则
                  _buildSectionTitle(theme, '50/30/20 法则'),
                  const SizedBox(height: 4),
                  Text(
                    '被广泛推荐的收入分配框架',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRuleBar(theme, 0.50, '必要支出', '房租、交通、伙食、通信、保险',
                      const Color(0xFFE57373)),
                  const SizedBox(height: 10),
                  _buildRuleBar(theme, 0.30, '想要的', '订阅、娱乐、外出、购物',
                      const Color(0xFF64B5F6)),
                  const SizedBox(height: 10),
                  _buildRuleBar(theme, 0.20, '储蓄与还债', '应急基金、投资、分期还款',
                      const Color(0xFF81C784)),
                  const SizedBox(height: 28),

                  // 分项健康占比（参考值）
                  _buildSectionTitle(theme, '各分项健康占比'),
                  const SizedBox(height: 16),
                  _buildCategoryTable(theme),
                  const SizedBox(height: 28),

                  // 你的分项健康度
                  if (settings.hasIncome) ...[
                    _buildSectionTitle(theme, '你的分项健康度'),
                    const SizedBox(height: 4),
                    Text(
                      '你的实际支出 vs 建议值',
                      style: TextStyle(
                          fontSize: 13, color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 16),
                    _buildUserCategoryHealth(theme, settings, vm),
                    const SizedBox(height: 28),
                  ],

                  // 幸福感等级说明
                  _buildSectionTitle(theme, '幸福感等级'),
                  const SizedBox(height: 16),
                  ...HappinessLevel.values
                      .where((l) => l != HappinessLevel.unknown)
                      .map((l) => _buildLevelRow(theme, l)),
                  const SizedBox(height: 28),

                  // 建议
                  _buildSectionTitle(theme, '改善建议'),
                  const SizedBox(height: 12),
                  _buildTipCard(theme, '1', '审查订阅',
                      '每季度检查一次所有订阅服务，取消不常用的。很多人不知不觉每月流失 ¥200+ 在遗忘的订阅上。'),
                  const SizedBox(height: 8),
                  _buildTipCard(theme, '2', '居住成本是最大杠杆',
                      '如果房租超过收入 30%，考虑换住处或合租。这一项的改善效果最大。'),
                  const SizedBox(height: 8),
                  _buildTipCard(theme, '3', '分期≠免费',
                      '分期只是把压力摊薄，但每一笔分期都在挤压你的自由支配空间。新增分期前先用模拟器算算。'),
                  const SizedBox(height: 8),
                  _buildTipCard(theme, '4', '先存后花',
                      '发工资第一天自动转 15-20% 到储蓄账户。剩下的才是你的「可花金额」。'),

                  const SizedBox(height: 40),

                  // 数据来源
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '参考研究：Elizabeth Warren 50/30/20 法则、'
                      'Kahneman & Deaton (2010) 收入与幸福感关系研究、'
                      '中国居民消费支出结构统计年鉴',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard(
    BuildContext context,
    ThemeData theme,
    SettingsViewModel settings,
    SleepCostDashboardViewModel vm,
    double ratio,
    HappinessLevel level,
    int score,
  ) {
    if (!settings.hasIncome) {
      return Card(
        child: InkWell(
          onTap: () => _showIncomeDialog(context, settings),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Text('🤔', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('还没设置月收入',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('点击输入收入，查看你的幸福感状态',
                          style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.outline)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      );
    }

    final monthlyCost = SettingsViewModel.dailyToMonthly(
        vm.summary.totalDailyCost);
    final freeAmount = settings.monthlyIncome - monthlyCost;
    final sColor = SettingsViewModel.scoreColor(score);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 评分大字
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: sColor,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    ' 分 · ${SettingsViewModel.scoreLabel(score)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: sColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(level.emoji, style: const TextStyle(fontSize: 28)),
            Text(
              level.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: level.color,
              ),
            ),
            const SizedBox(height: 16),
            // 进度条
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(level.color),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '固定支出 ${(ratio * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 13, color: theme.colorScheme.outline),
                ),
                Text(
                  '月结余 ${settings.currency}${freeAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        freeAmount > 0 ? Colors.green.shade700 : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip(theme, '月收入',
                    '¥${settings.monthlyIncome.toStringAsFixed(0)}'),
                const SizedBox(width: 8),
                _buildStatChip(
                    theme, '固定支出', '¥${monthlyCost.toStringAsFixed(0)}'),
                const SizedBox(width: 8),
                _buildStatChip(
                    theme, '可支配', '¥${freeAmount.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(label,
                style:
                    TextStyle(fontSize: 10, color: theme.colorScheme.outline)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInsightCard(
    ThemeData theme, {
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildRuleBar(
      ThemeData theme, double ratio, String label, String desc, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            '${(ratio * 100).toInt()}%',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              Text(desc,
                  style: TextStyle(
                      fontSize: 11, color: theme.colorScheme.outline)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTable(ThemeData theme) {
    final items = [
      ('居住（房租/房贷）', '≤ 30%', '> 35%', const Color(0xFFE57373)),
      ('交通', '≤ 10%', '> 15%', const Color(0xFF64B5F6)),
      ('日常生活', '10-15%', '—', const Color(0xFFFFB74D)),
      ('通信+订阅', '≤ 5%', '> 8%', const Color(0xFF9575CD)),
      ('分期还款', '≤ 10%', '> 20%', const Color(0xFFFF9800)),
      ('保险+医疗', '5-8%', '—', const Color(0xFF81C784)),
      ('自由支配', '≥ 10%', '< 5%', const Color(0xFF4DB6AC)),
      ('储蓄/投资', '≥ 15%', '< 10%', const Color(0xFFFFD54F)),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const Expanded(
                    flex: 3,
                    child: Text('分类',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(
                    flex: 2,
                    child: Text('健康',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700))),
                Expanded(
                    flex: 2,
                    child: Text('警戒',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600))),
              ],
            ),
          ),
          // 数据行
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final (name, healthy, warning, color) = entry.value;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: i.isEven ? null : theme.colorScheme.surfaceContainerLow,
                borderRadius: i == items.length - 1
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(11))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(name,
                          style: const TextStyle(fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text(healthy,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade700))),
                  Expanded(
                      flex: 2,
                      child: Text(warning,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.red.shade600))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 每个大类的建议占比上限和警戒线
  static const _categoryBenchmarks = <CostCategoryGroup, (double healthy, double warning, String label)>{
    CostCategoryGroup.housing: (0.30, 0.35, '居住'),
    CostCategoryGroup.transport: (0.10, 0.15, '交通'),
    CostCategoryGroup.living: (0.15, 0.20, '生活'),
    CostCategoryGroup.communication: (0.05, 0.08, '通信'),
    CostCategoryGroup.digitalSubscription: (0.05, 0.08, '数字订阅'),
    CostCategoryGroup.healthCare: (0.08, 0.12, '医疗健康'),
    CostCategoryGroup.education: (0.08, 0.12, '教育'),
    CostCategoryGroup.other: (0.05, 0.10, '其他'),
  };

  Widget _buildUserCategoryHealth(
    ThemeData theme,
    SettingsViewModel settings,
    SleepCostDashboardViewModel vm,
  ) {
    final income = settings.monthlyIncome;
    final summary = vm.summary;

    // 构建每个分类的数据
    final rows = <Widget>[];
    for (final group in CostCategoryGroup.values) {
      final dailyCost = summary.groupDailyCosts[group] ?? 0;
      if (dailyCost <= 0) continue;

      final monthlyCost = SettingsViewModel.dailyToMonthly(dailyCost);
      final actualRatio = monthlyCost / income;
      final benchmark = _categoryBenchmarks[group];
      if (benchmark == null) continue;

      final (healthy, warning, _) = benchmark;
      rows.add(_buildHealthBar(
        theme,
        icon: group.icon,
        color: group.color,
        name: group.displayName,
        amount: monthlyCost,
        actualRatio: actualRatio,
        healthyMax: healthy,
        warningMax: warning,
        currency: settings.currency,
      ));
    }

    // 分期单独一行
    if (summary.installmentDaily > 0) {
      final monthlyCost = SettingsViewModel.dailyToMonthly(summary.installmentDaily);
      final actualRatio = monthlyCost / income;
      rows.add(_buildHealthBar(
        theme,
        icon: Icons.credit_card,
        color: const Color(0xFFFF9800),
        name: '分期还款',
        amount: monthlyCost,
        actualRatio: actualRatio,
        healthyMax: 0.10,
        warningMax: 0.20,
        currency: settings.currency,
      ));
    }

    if (rows.isEmpty) {
      return Text('暂无支出数据',
          style: TextStyle(color: theme.colorScheme.outline));
    }

    return Column(children: rows);
  }

  Widget _buildHealthBar(
    ThemeData theme, {
    required IconData icon,
    required Color color,
    required String name,
    required double amount,
    required double actualRatio,
    required double healthyMax,
    required double warningMax,
    required String currency,
  }) {
    // 状态判定
    final String statusText;
    final Color statusColor;
    final IconData statusIcon;
    if (actualRatio <= healthyMax) {
      statusText = '健康';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (actualRatio <= warningMax) {
      statusText = '偏高';
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusText = '超标';
      statusColor = Colors.red;
      statusIcon = Icons.error;
    }

    // 进度条最大值：取 warningMax * 1.2 或实际值的较大者，保证看得到
    final barMax = actualRatio > warningMax * 1.2
        ? actualRatio * 1.1
        : warningMax * 1.2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(statusText,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor)),
            ],
          ),
          const SizedBox(height: 6),
          // 进度条 + 标记线
          SizedBox(
            height: 20,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final actualPos =
                    (actualRatio / barMax * width).clamp(0.0, width);
                final healthyPos =
                    (healthyMax / barMax * width).clamp(0.0, width);

                return Stack(
                  children: [
                    // 背景
                    Container(
                      height: 10,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // 实际值
                    Container(
                      height: 10,
                      width: actualPos,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // 建议线
                    Positioned(
                      left: healthyPos - 1,
                      top: 0,
                      child: Container(
                        width: 2,
                        height: 14,
                        color: Colors.green.shade700,
                      ),
                    ),
                    // 建议线标签
                    Positioned(
                      left: healthyPos + 4,
                      top: 0,
                      child: Text(
                        '${(healthyMax * 100).toInt()}%',
                        style: TextStyle(
                            fontSize: 9, color: Colors.green.shade700),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 2),
          // 数值
          Text(
            '$currency${amount.toStringAsFixed(0)}/月 · 占收入 ${(actualRatio * 100).toStringAsFixed(1)}%（建议 ≤${(healthyMax * 100).toInt()}%）',
            style:
                TextStyle(fontSize: 11, color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRow(ThemeData theme, HappinessLevel level) {
    final ranges = {
      HappinessLevel.excellent: '≤ 40%',
      HappinessLevel.good: '41% - 55%',
      HappinessLevel.normal: '56% - 70%',
      HappinessLevel.tight: '71% - 85%',
      HappinessLevel.stressed: '> 85%',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: level.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: level.color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(level.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level.label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: level.color)),
                  Text('固定支出占收入 ${ranges[level]}',
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
      ThemeData theme, String number, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(number,
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(body,
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: theme.colorScheme.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showIncomeDialog(BuildContext context, SettingsViewModel settings) {
    final controller = TextEditingController(
      text: settings.monthlyIncome > 0
          ? settings.monthlyIncome.toStringAsFixed(0)
          : '',
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
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(
                      controller.text.replaceAll(',', '.')) ??
                  0;
              settings.setMonthlyIncome(value);
              Navigator.of(ctx).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
