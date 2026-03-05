// get_upcoming_obligations_usecase.dart
// LifeCostTracker
// Created by LifeCostTracker Team

import '../entities/credit_account.dart';
import '../entities/subscription.dart';
import '../repositories/credit_account_repository.dart';
import '../repositories/subscription_repository.dart';
import 'base_usecase.dart';

class Obligation {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final ObligationType type;

  Obligation({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.type,
  });
}

enum ObligationType {
  subscription,
  creditPayment,
}

class GetUpcomingObligationsUseCase
    implements BaseUseCase<List<Obligation>, NoParams> {
  final CreditAccountRepository creditAccountRepository;
  final SubscriptionRepository subscriptionRepository;

  GetUpcomingObligationsUseCase({
    required this.creditAccountRepository,
    required this.subscriptionRepository,
  });

  @override
  Future<List<Obligation>> call(NoParams params) async {
    final obligations = <Obligation>[];

    // Get upcoming credit payments
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

    // Sort by due date
    obligations.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return obligations;
  }
}
