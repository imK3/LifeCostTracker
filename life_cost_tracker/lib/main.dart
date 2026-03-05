import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/adapters/expense_adapter.dart';
import 'data/adapters/expense_category_adapter.dart';
import 'data/adapters/credit_account_adapter.dart';
import 'data/adapters/credit_account_type_adapter.dart';
import 'data/adapters/subscription_adapter.dart';
import 'data/adapters/billing_cycle_adapter.dart';
import 'data/adapters/subscription_category_adapter.dart';
import 'data/adapters/wishlist_item_adapter.dart';
import 'data/adapters/priority_adapter.dart';

import 'data/repositories/hive_expense_repository.dart';
import 'data/repositories/hive_credit_account_repository.dart';
import 'data/repositories/hive_subscription_repository.dart';
import 'data/repositories/hive_wishlist_item_repository.dart';

import 'domain/entities/expense.dart';
import 'domain/entities/credit_account.dart';
import 'domain/entities/subscription.dart';
import 'domain/entities/wishlist_item.dart';

import 'domain/usecases/add_expense_usecase.dart';
import 'domain/usecases/get_expenses_usecase.dart';
import 'domain/usecases/add_credit_account_usecase.dart';
import 'domain/usecases/calculate_credit_utilization_usecase.dart';
import 'domain/usecases/add_subscription_usecase.dart';
import 'domain/usecases/get_upcoming_obligations_usecase.dart';
import 'domain/usecases/add_wishlist_item_usecase.dart';
import 'domain/usecases/calculate_average_daily_cost_usecase.dart';
import 'domain/usecases/check_affordability_usecase.dart';
import 'domain/usecases/calculate_daily_cost_breakdown_usecase.dart';
import 'domain/usecases/check_wishlist_daily_cost_impact_usecase.dart';
import 'domain/usecases/calculate_wishlist_daily_savings_target_usecase.dart';
import 'domain/usecases/generate_monthly_report_usecase.dart';
import 'domain/usecases/generate_daily_cost_trend_usecase.dart';
import 'domain/usecases/compare_wishlist_daily_costs_usecase.dart';

import 'presentation/viewmodels/home_dashboard_view_model.dart';
import 'presentation/viewmodels/all_items_list_view_model.dart';
import 'presentation/viewmodels/add_new_item_view_model.dart';
import 'presentation/viewmodels/item_detail_view_model.dart';
import 'presentation/viewmodels/reports_view_model.dart';
import 'presentation/viewmodels/settings_view_model.dart';
import 'presentation/views/home_dashboard_view.dart';

void main() async {
  // Initialize Hive
  // 初始化 Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register TypeAdapters
  // 注册类型适配器
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(ExpenseCategoryAdapter());
  Hive.registerAdapter(CreditAccountAdapter());
  Hive.registerAdapter(CreditAccountTypeAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(BillingCycleAdapter());
  Hive.registerAdapter(SubscriptionCategoryAdapter());
  Hive.registerAdapter(WishlistItemAdapter());
  Hive.registerAdapter(PriorityAdapter());

  // Open Hive boxes
  // 打开 Hive boxes
  final expenseBox = await Hive.openBox<Expense>('expenses');
  final creditAccountBox = await Hive.openBox<CreditAccount>('credit_accounts');
  final subscriptionBox = await Hive.openBox<Subscription>('subscriptions');
  final wishlistItemBox = await Hive.openBox<WishlistItem>('wishlist_items');

  // Create repository instances
  // 创建仓库实例
  final expenseRepository = HiveExpenseRepository(expenseBox);
  final creditAccountRepository = HiveCreditAccountRepository(creditAccountBox);
  final subscriptionRepository = HiveSubscriptionRepository(subscriptionBox);
  final wishlistItemRepository = HiveWishlistItemRepository(wishlistItemBox);

  // Create use case instances
  // 创建用例实例
  final addExpenseUseCase = AddExpenseUseCase(expenseRepository: expenseRepository);
  final getExpensesUseCase = GetExpensesUseCase(expenseRepository: expenseRepository);
  final addCreditAccountUseCase = AddCreditAccountUseCase(creditAccountRepository: creditAccountRepository);
  final calculateCreditUtilizationUseCase = CalculateCreditUtilizationUseCase(creditAccountRepository: creditAccountRepository);
  final addSubscriptionUseCase = AddSubscriptionUseCase(subscriptionRepository: subscriptionRepository);
  final getUpcomingObligationsUseCase = GetUpcomingObligationsUseCase(creditAccountRepository: creditAccountRepository, subscriptionRepository: subscriptionRepository);
  final addWishlistItemUseCase = AddWishlistItemUseCase(wishlistItemRepository: wishlistItemRepository);
  final calculateAverageDailyCostUseCase = CalculateAverageDailyCostUseCase(expenseRepository: expenseRepository, subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final checkAffordabilityUseCase = CheckAffordabilityUseCase(expenseRepository: expenseRepository, subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final calculateDailyCostBreakdownUseCase = CalculateDailyCostBreakdownUseCase(subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final checkWishlistDailyCostImpactUseCase = CheckWishlistDailyCostImpactUseCase(expenseRepository: expenseRepository, subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final calculateWishlistDailySavingsTargetUseCase = CalculateWishlistDailySavingsTargetUseCase(wishlistItemRepository: wishlistItemRepository);
  final generateMonthlyReportUseCase = GenerateMonthlyReportUseCase(expenseRepository: expenseRepository, subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final generateDailyCostTrendUseCase = GenerateDailyCostTrendUseCase(expenseRepository: expenseRepository, subscriptionRepository: subscriptionRepository, wishlistItemRepository: wishlistItemRepository);
  final compareWishlistDailyCostsUseCase = CompareWishlistDailyCostsUseCase(wishlistItemRepository: wishlistItemRepository);

  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider.value(value: expenseRepository),
        Provider.value(value: creditAccountRepository),
        Provider.value(value: subscriptionRepository),
        Provider.value(value: wishlistItemRepository),
        
        // Use Cases
        Provider.value(value: addExpenseUseCase),
        Provider.value(value: getExpensesUseCase),
        Provider.value(value: addCreditAccountUseCase),
        Provider.value(value: calculateCreditUtilizationUseCase),
        Provider.value(value: addSubscriptionUseCase),
        Provider.value(value: getUpcomingObligationsUseCase),
        Provider.value(value: addWishlistItemUseCase),
        Provider.value(value: calculateAverageDailyCostUseCase),
        Provider.value(value: checkAffordabilityUseCase),
        Provider.value(value: calculateDailyCostBreakdownUseCase),
        Provider.value(value: checkWishlistDailyCostImpactUseCase),
        Provider.value(value: calculateWishlistDailySavingsTargetUseCase),
        Provider.value(value: generateMonthlyReportUseCase),
        Provider.value(value: generateDailyCostTrendUseCase),
        Provider.value(value: compareWishlistDailyCostsUseCase),
        
        // View Models
        ChangeNotifierProvider(
          create: (context) => HomeDashboardViewModel(
            expenseRepository: expenseRepository,
            subscriptionRepository: subscriptionRepository,
            creditAccountRepository: creditAccountRepository,
            calculateAverageDailyCostUseCase: calculateAverageDailyCostUseCase,
            getUpcomingObligationsUseCase: getUpcomingObligationsUseCase,
            calculateCreditUtilizationUseCase: calculateCreditUtilizationUseCase,
            calculateDailyCostBreakdownUseCase: calculateDailyCostBreakdownUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AllItemsListViewModel(
            expenseRepository: expenseRepository,
            subscriptionRepository: subscriptionRepository,
            wishlistItemRepository: wishlistItemRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddNewItemViewModel(
            addExpenseUseCase: addExpenseUseCase,
            addSubscriptionUseCase: addSubscriptionUseCase,
            addWishlistItemUseCase: addWishlistItemUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ItemDetailViewModel(
            expenseRepository: expenseRepository,
            subscriptionRepository: subscriptionRepository,
            wishlistItemRepository: wishlistItemRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportsViewModel(
            generateMonthlyReportUseCase: generateMonthlyReportUseCase,
            generateDailyCostTrendUseCase: generateDailyCostTrendUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeCostTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeDashboardView(),
    );
  }
}
