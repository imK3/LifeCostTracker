import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Adapters
import 'data/adapters/recurring_cost_adapter.dart';
import 'data/adapters/cost_category_adapter.dart';
import 'data/adapters/billing_cycle_adapter.dart';
import 'data/adapters/installment_plan_adapter.dart';
import 'data/adapters/affordability_item_adapter.dart';

// Repositories
import 'data/repositories/hive_recurring_cost_repository.dart';
import 'data/repositories/hive_installment_plan_repository.dart';
import 'data/repositories/hive_affordability_item_repository.dart';

// Entities
import 'domain/entities/recurring_cost.dart';
import 'domain/entities/installment_plan.dart';
import 'domain/entities/affordability_item.dart';

// Use Cases
import 'domain/usecases/calculate_sleep_cost_usecase.dart';
import 'domain/usecases/simulate_affordability_usecase.dart';
import 'domain/usecases/manage_recurring_cost_usecase.dart';
import 'domain/usecases/manage_installment_plan_usecase.dart';
import 'domain/usecases/manage_affordability_item_usecase.dart';

// ViewModels
import 'presentation/viewmodels/sleep_cost_dashboard_view_model.dart';
import 'presentation/viewmodels/add_cost_item_view_model.dart';
import 'presentation/viewmodels/affordability_simulator_view_model.dart';
import 'presentation/viewmodels/cost_item_detail_view_model.dart';
import 'presentation/viewmodels/settings_view_model.dart';

// Views
import 'presentation/views/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register TypeAdapters (typeId 10+)
  Hive.registerAdapter(RecurringCostAdapter());
  Hive.registerAdapter(CostCategoryAdapter());
  Hive.registerAdapter(BillingCycleAdapter());
  Hive.registerAdapter(InstallmentPlanAdapter());
  Hive.registerAdapter(AffordabilityItemAdapter());

  // Open Hive boxes
  final recurringCostBox =
      await Hive.openBox<RecurringCost>('recurring_costs');
  final installmentPlanBox =
      await Hive.openBox<InstallmentPlan>('installment_plans');
  final affordabilityItemBox =
      await Hive.openBox<AffordabilityItem>('affordability_items');

  // Create repository instances
  final recurringCostRepository =
      HiveRecurringCostRepository(recurringCostBox);
  final installmentPlanRepository =
      HiveInstallmentPlanRepository(installmentPlanBox);
  final affordabilityItemRepository =
      HiveAffordabilityItemRepository(affordabilityItemBox);

  // Create use case instances
  final addRecurringCostUseCase =
      AddRecurringCostUseCase(repository: recurringCostRepository);
  final updateRecurringCostUseCase =
      UpdateRecurringCostUseCase(repository: recurringCostRepository);
  final deleteRecurringCostUseCase =
      DeleteRecurringCostUseCase(repository: recurringCostRepository);

  final addInstallmentPlanUseCase =
      AddInstallmentPlanUseCase(repository: installmentPlanRepository);
  final updateInstallmentPlanUseCase =
      UpdateInstallmentPlanUseCase(repository: installmentPlanRepository);
  final deleteInstallmentPlanUseCase =
      DeleteInstallmentPlanUseCase(repository: installmentPlanRepository);

  final addAffordabilityItemUseCase =
      AddAffordabilityItemUseCase(repository: affordabilityItemRepository);
  final getAffordabilityItemsUseCase =
      GetAffordabilityItemsUseCase(repository: affordabilityItemRepository);
  final deleteAffordabilityItemUseCase =
      DeleteAffordabilityItemUseCase(repository: affordabilityItemRepository);

  final calculateSleepCostUseCase = CalculateSleepCostUseCase(
    recurringCostRepository: recurringCostRepository,
    installmentPlanRepository: installmentPlanRepository,
  );

  final simulateAffordabilityUseCase = SimulateAffordabilityUseCase(
    calculateSleepCostUseCase: calculateSleepCostUseCase,
  );

  runApp(
    MultiProvider(
      providers: [
        // Settings (global)
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(),
        ),

        // Dashboard
        ChangeNotifierProvider(
          create: (_) => SleepCostDashboardViewModel(
            calculateSleepCostUseCase: calculateSleepCostUseCase,
          ),
        ),

        // Add cost item
        ChangeNotifierProvider(
          create: (_) => AddCostItemViewModel(
            addRecurringCostUseCase: addRecurringCostUseCase,
            addInstallmentPlanUseCase: addInstallmentPlanUseCase,
          ),
        ),

        // Affordability simulator
        ChangeNotifierProvider(
          create: (_) => AffordabilitySimulatorViewModel(
            simulateUseCase: simulateAffordabilityUseCase,
            getItemsUseCase: getAffordabilityItemsUseCase,
            addItemUseCase: addAffordabilityItemUseCase,
            deleteItemUseCase: deleteAffordabilityItemUseCase,
          ),
        ),

        // Cost item detail
        ChangeNotifierProvider(
          create: (_) => CostItemDetailViewModel(
            updateRecurringCostUseCase: updateRecurringCostUseCase,
            deleteRecurringCostUseCase: deleteRecurringCostUseCase,
            updateInstallmentPlanUseCase: updateInstallmentPlanUseCase,
            deleteInstallmentPlanUseCase: deleteInstallmentPlanUseCase,
          ),
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
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}
