// onboarding_view.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 新手引导视图
// Onboarding View

import 'package:flutter/material.dart';
import 'main_navigation.dart';

/// Onboarding View - first launch welcome guide
/// 新手引导视图 - 首次启动欢迎引导
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.calculate_outlined,
      'title': '换个视角管钱',
      'subtitle': '把大笔开销换算成每日成本，立刻知道值不值。¥7/天能接受，¥2500一次就心疼。',
      'color': Colors.blue,
    },
    {
      'icon': Icons.add_shopping_cart_outlined,
      'title': '记录每笔开销',
      'subtitle': '无论是买新手机、订阅会员还是加购物车，一键录入，自动计算每日使用成本。',
      'color': Colors.green,
    },
    {
      'icon': Icons.bar_chart_outlined,
      'title': '掌控你的消费',
      'subtitle': '直观看到你的每日平均开销、订阅支出，帮你轻松控制剁手欲望，理性消费。',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPage(
                  icon: _pages[index]['icon'] as IconData,
                  title: _pages[index]['title'] as String,
                  subtitle: _pages[index]['subtitle'] as String,
                  color: _pages[index]['color'] as Color,
                );
              },
            ),
          ),

          // Page indicators
          // 页面指示器
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return Container(
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                );
              }),
            ),
          ),

          // Action buttons
          // 操作按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _completeOnboarding(),
                  child: const Text('跳过'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentPage == _pages.length - 1 ? '开始使用' : '下一页'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build onboarding page
  /// 构建引导页
  Widget _buildPage({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 64,
              color: color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Complete onboarding and navigate to main screen
  /// 完成引导，导航到主页面
  void _completeOnboarding() {
    // TODO: 这里可以加上标记用户已经看过引导，下次启动直接进首页
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }
}
