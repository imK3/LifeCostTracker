// payment_calendar_view.dart
// LifeCostTracker
// 缴费日历 — 日历样式查看未来缴费计划

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sleep_cost_dashboard_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import '../../domain/entities/recurring_cost.dart';
import '../../domain/entities/installment_plan.dart';
import '../../domain/entities/billing_cycle.dart';
import 'cost_item_detail_view.dart';

class PaymentCalendarView extends StatefulWidget {
  const PaymentCalendarView({super.key});

  @override
  State<PaymentCalendarView> createState() => _PaymentCalendarViewState();
}

class _PaymentCalendarViewState extends State<PaymentCalendarView> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<SleepCostDashboardViewModel>();
    final settings = context.watch<SettingsViewModel>();

    // 收集所有未来待缴项（周期性 + 分期）
    final events = _buildEvents(vm);

    return Scaffold(
      appBar: AppBar(
        title: const Text('缴费日历'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 月份切换
          _buildMonthHeader(theme),
          // 日历网格
          _buildCalendarGrid(theme, events, settings),
          const Divider(height: 1),
          // 选中日期的详情
          Expanded(
            child: _buildDayDetail(theme, events, settings),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(
                    _focusedMonth.year, _focusedMonth.month - 1);
                _selectedDate = null;
              });
            },
          ),
          Text(
            '${_focusedMonth.year}年${_focusedMonth.month}月',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedMonth = DateTime(
                    _focusedMonth.year, _focusedMonth.month + 1);
                _selectedDate = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
    ThemeData theme,
    Map<int, List<_CalendarEvent>> events,
    SettingsViewModel settings,
  ) {
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    // 周一=1 开始
    final leadingBlanks = (firstWeekday - 1) % 7;
    final today = DateTime.now();
    final isCurrentMonth = _focusedMonth.year == today.year &&
        _focusedMonth.month == today.month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // 星期标题
          Row(
            children: ['一', '二', '三', '四', '五', '六', '日']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.outline,
                            )),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          // 日期格子
          ...List.generate(
            ((leadingBlanks + daysInMonth) / 7).ceil(),
            (week) {
              return Row(
                children: List.generate(7, (weekday) {
                  final dayIndex = week * 7 + weekday - leadingBlanks + 1;
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 52));
                  }

                  final dayEvents = events[dayIndex] ?? [];
                  final isToday = isCurrentMonth && dayIndex == today.day;
                  final isSelected = _selectedDate != null &&
                      _selectedDate!.day == dayIndex &&
                      _selectedDate!.month == _focusedMonth.month &&
                      _selectedDate!.year == _focusedMonth.year;
                  final totalAmount = dayEvents.fold<double>(
                      0, (sum, e) => sum + e.amount);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime(
                              _focusedMonth.year, _focusedMonth.month,
                              dayIndex);
                        });
                      },
                      child: Container(
                        height: 52,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : isToday
                                  ? theme.colorScheme.surfaceContainerHighest
                                  : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayIndex',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                            if (dayEvents.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                '¥${totalAmount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetail(
    ThemeData theme,
    Map<int, List<_CalendarEvent>> events,
    SettingsViewModel settings,
  ) {
    if (_selectedDate == null) {
      // 默认显示本月汇总
      final allEvents = events.values.expand((e) => e).toList();
      final totalAmount =
          allEvents.fold<double>(0, (sum, e) => sum + e.amount);
      if (allEvents.isEmpty) {
        return Center(
          child: Text('本月无待缴项目',
              style: TextStyle(color: theme.colorScheme.outline)),
        );
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '本月待缴合计 ${settings.currency}${totalAmount.toStringAsFixed(0)}（${allEvents.length} 项）',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...allEvents.map((e) => _buildEventTile(theme, settings, e)),
        ],
      );
    }

    final dayEvents = events[_selectedDate!.day] ?? [];
    if (dayEvents.isEmpty) {
      return Center(
        child: Text(
          '${_selectedDate!.month}/${_selectedDate!.day} 无待缴项目',
          style: TextStyle(color: theme.colorScheme.outline),
        ),
      );
    }

    final totalAmount =
        dayEvents.fold<double>(0, (sum, e) => sum + e.amount);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${_selectedDate!.month}月${_selectedDate!.day}日 待缴 ${settings.currency}${totalAmount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...dayEvents.map((e) => _buildEventTile(theme, settings, e)),
      ],
    );
  }

  Widget _buildEventTile(
      ThemeData theme, SettingsViewModel settings, _CalendarEvent event) {
    return ListTile(
      leading: Icon(event.icon, color: event.color),
      title: Text(event.name),
      subtitle: Text(event.subtitle),
      trailing: Text(
        '${settings.currency}${event.amount.toStringAsFixed(0)}',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        if (event.recurringCost != null) {
          _navigateToDetail(recurringCost: event.recurringCost);
        } else if (event.installmentPlan != null) {
          _navigateToDetail(installmentPlan: event.installmentPlan);
        }
      },
    );
  }

  void _navigateToDetail({
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

  /// 从 summary 构建日历事件映射：day → events
  ///
  /// 核心逻辑：根据 nextDueDate 和 billingCycle 反推/正推
  /// 该项在 focusedMonth 的到期日，而不是只看当前 nextDueDate。
  Map<int, List<_CalendarEvent>> _buildEvents(
      SleepCostDashboardViewModel vm) {
    final Map<int, List<_CalendarEvent>> events = {};
    final summary = vm.summary;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    void addEvent(int day, _CalendarEvent event) {
      events.putIfAbsent(day, () => []);
      events[day]!.add(event);
    }

    // 计算周期性项在 focusedMonth 的到期日
    for (final item in [...summary.unpaidItems, ...summary.paidItems]) {
      final dueDay = _findDueDayInMonth(
        item.nextDueDate,
        item.billingCycle,
        _focusedMonth,
        item.startDate,
      );
      if (dueDay == null) continue;

      if (dueDay == -1) {
        // 周付：找出该月所有对应星期几的日期
        final weekday = item.nextDueDate.weekday;
        final daysInMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
        for (var d = 1; d <= daysInMonth; d++) {
          if (DateTime(_focusedMonth.year, _focusedMonth.month, d).weekday ==
              weekday) {
            final dueDate =
                DateTime(_focusedMonth.year, _focusedMonth.month, d);
            final isPaid = !dueDate.isAfter(today);
            addEvent(d, _CalendarEvent(
              name: item.name,
              subtitle: '每周 · ${item.category.displayName}${isPaid ? " · 已缴" : ""}',
              amount: item.paymentAmount,
              icon: item.category.icon,
              color: isPaid ? Colors.green : item.category.group.color,
              recurringCost: item,
              isPaid: isPaid,
            ));
          }
        }
        continue;
      }

      final dueDate = DateTime(_focusedMonth.year, _focusedMonth.month, dueDay);
      final isPast = !dueDate.isAfter(today);
      final isPaid = isPast ||
          (item.isPaidForCurrentPeriod &&
              item.nextDueDate.year == _focusedMonth.year &&
              item.nextDueDate.month == _focusedMonth.month);

      addEvent(dueDay, _CalendarEvent(
        name: item.name,
        subtitle:
            '${item.billingCycle.displayName} · ${item.category.displayName}${isPaid ? " · 已缴" : ""}',
        amount: item.paymentAmount,
        icon: item.category.icon,
        color: isPaid ? Colors.green : item.category.group.color,
        recurringCost: item,
        isPaid: isPaid,
      ));
    }

    // 计算分期项在 focusedMonth 的到期日
    for (final item in summary.installmentItems) {
      if (item.isCompleted) continue;

      // 从 nextDueDate 往前/往后推算，找到 focusedMonth 的到期日
      final dueDateInMonth = _findInstallmentDueInMonth(item);
      if (dueDateInMonth == null) continue;

      final dueDay = dueDateInMonth['day'] as int;
      final periodIndex = dueDateInMonth['periodIndex'] as int;
      final dueDate = DateTime(_focusedMonth.year, _focusedMonth.month, dueDay);
      final isPast = !dueDate.isAfter(today);
      final isPaid = isPast ||
          (periodIndex == 0 && item.isPaidForCurrentPeriod);

      addEvent(dueDay, _CalendarEvent(
        name: item.name,
        subtitle:
            '分期 ${item.paidPeriods + periodIndex}/${item.totalPeriods}期${isPaid ? " · 已缴" : ""}',
        amount: item.monthlyPayment,
        icon: Icons.credit_card,
        color: isPaid ? Colors.green : const Color(0xFFFF9800),
        installmentPlan: item,
        isPaid: isPaid,
      ));
    }

    return events;
  }

  /// 计算周期性项在指定月份的到期日（天数），无则返回 null
  int? _findDueDayInMonth(
    DateTime nextDueDate,
    BillingCycle cycle,
    DateTime month,
    DateTime startDate,
  ) {
    // 确保项目已经开始
    if (DateTime(month.year, month.month + 1, 0).isBefore(startDate)) {
      return null;
    }

    switch (cycle) {
      case BillingCycle.weekly:
        // 周付：返回 -1 作为特殊标记，调用方需要处理多日
        return -1;

      case BillingCycle.monthly:
        // 月付：每月同一天
        final maxDay =
            DateTime(month.year, month.month + 1, 0).day;
        return nextDueDate.day.clamp(1, maxDay);

      case BillingCycle.quarterly:
        // 季付：每3个月一次，检查 focusedMonth 是否和 nextDueDate 在同一季度周期上
        // 用起始月份的模3余数对齐
        final baseRemainder = nextDueDate.month % 3;
        final focusRemainder = month.month % 3;
        if (baseRemainder != focusRemainder) return null;
        final maxDay =
            DateTime(month.year, month.month + 1, 0).day;
        return nextDueDate.day.clamp(1, maxDay);

      case BillingCycle.yearly:
        // 年付：每年同月同日
        if (month.month != nextDueDate.month) return null;
        final maxDay =
            DateTime(month.year, month.month + 1, 0).day;
        return nextDueDate.day.clamp(1, maxDay);
    }
  }

  /// 计算分期项在 focusedMonth 的到期信息
  Map<String, int>? _findInstallmentDueInMonth(InstallmentPlan item) {
    // 分期是月付，从 nextDueDate 往前/往后找 focusedMonth
    var dueDate = item.nextDueDate;
    var periodOffset = 0; // 相对于当前期的偏移

    // 往前找（当前期或之前的期）
    while (DateTime(dueDate.year, dueDate.month).isAfter(
        DateTime(_focusedMonth.year, _focusedMonth.month))) {
      dueDate = DateTime(dueDate.year, dueDate.month - 1, dueDate.day);
      periodOffset--;
      if (periodOffset < -item.paidPeriods) return null; // 超出开始时间
    }

    // 往后找
    while (DateTime(dueDate.year, dueDate.month).isBefore(
        DateTime(_focusedMonth.year, _focusedMonth.month))) {
      dueDate = DateTime(dueDate.year, dueDate.month + 1, dueDate.day);
      periodOffset++;
      if (periodOffset >= item.remainingPeriods) return null; // 超出结束时间
    }

    // 检查是否匹配
    if (dueDate.year == _focusedMonth.year &&
        dueDate.month == _focusedMonth.month) {
      final maxDay =
          DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
      return {
        'day': dueDate.day.clamp(1, maxDay),
        'periodIndex': periodOffset,
      };
    }
    return null;
  }
}

/// 日历事件数据
class _CalendarEvent {
  final String name;
  final String subtitle;
  final double amount;
  final IconData icon;
  final Color color;
  final RecurringCost? recurringCost;
  final InstallmentPlan? installmentPlan;
  final bool isPaid;

  const _CalendarEvent({
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.color,
    this.recurringCost,
    this.installmentPlan,
    this.isPaid = false,
  });
}
