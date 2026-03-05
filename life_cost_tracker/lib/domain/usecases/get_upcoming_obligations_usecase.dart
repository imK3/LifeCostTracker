// get_upcoming_obligations_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';
import '../entities/subscription.dart';
import '../repositories/credit_account_repository.dart';
import '../repositories/subscription_repository.dart';
import 'base_usecase.dart';

/// Represents a financial obligation (e.g., credit payment or subscription)
/// 表示一项财务义务（例如：信用卡还款或订阅费用）
class Obligation {
  /// Unique identifier
  /// 唯一标识符
  final String id;

  /// Name of the obligation
  /// 义务名称
  final String name;

  /// Amount due
  /// 到期金额
  final double amount;

  /// Due date
  /// 到期日
  final DateTime dueDate;

  /// Type of the obligation
  /// 义务类型
  final ObligationType type;

  Obligation({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.type,
  });
}

/// Obligation type enum
/// 义务类型枚举
enum ObligationType {
  /// Subscription renewal
  /// 订阅续费
  subscription,

  /// Credit card or loan payment
  /// 信用卡或贷款还款
  creditPayment,
}

/// Get upcoming obligations use case
/// 获取即将到期的义务用例
class GetUpcomingObligationsUseCase
    implements BaseUseCase<List<Obligation>, NoParams> {
  /// Credit account repository
  /// 信用账户仓库
  final CreditAccountRepository creditAccountRepository;

  /// Subscription repository
  /// 订阅仓库
  final SubscriptionRepository subscriptionRepository;

  /// Constructor
  /// 构造函数
  GetUpcomingObligationsUseCase({
    required this.creditAccountRepository,
    required this.subscriptionRepository,
  });

  /// Execute the use case to fetch and combine all upcoming obligations
  /// 执行用例以获取并合并所有即将到期的义务
  @override
  Future<List<Obligation>> call(NoParams params) async {
    final obligations = <Obligation>[];

    // Get upcoming credit payments
    // 获取即将到期的信用卡还款
    final creditAccounts = await creditAccountRepository.getCreditAccounts();
    for (final account in creditAccounts) {
      if (account.dueDate != null &&
          account.dueDate!.isAfter(DateTime.now())) {
        obligations.add(
          Obligation(
            id: account.id,
            name: account.name,
            amount: account.minimumPayment ?? account.balance,
            dueDate: account.dueDate!,
            type: ObligationType.creditPayment,
          ),
        );
      }
    }

    // Get upcoming subscriptions
    // 获取即将到期的订阅续费
    final subscriptions = await subscriptionRepository.getSubscriptions();
    for (final subscription in subscriptions) {
      if (subscription.nextBillingDate.isAfter(DateTime.now())) {
        obligations.add(
          Obligation(
            id: subscription.id,
            name: subscription.name,
            amount: subscription.cost,
            dueDate: subscription.nextBillingDate,
            type: ObligationType.subscription,
          ),
        );
      }
    }

    // Sort by due date (ascending)
    // 按到期日升序排序
    obligations.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return obligations;
  }
}
