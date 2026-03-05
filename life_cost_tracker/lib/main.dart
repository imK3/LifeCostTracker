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
  await Hive.openBox('expenses');
  await Hive.openBox('credit_accounts');
  await Hive.openBox('subscriptions');
  await Hive.openBox('wishlist_items');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeCostTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Home screen - main dashboard
/// 主屏幕 - 主仪表板
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeCostTracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Welcome to LifeCostTracker!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Track your daily costs and achieve financial freedom',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              '🚀 Coming Soon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
