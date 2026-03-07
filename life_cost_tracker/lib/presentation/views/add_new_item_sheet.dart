// add_new_item_sheet.dart
// LifeCostTracker
// Created by LifeCostTracker Team
// 添加新物品表单
// Add New Item Sheet

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/add_new_item_view_model.dart';

/// Add New Item Sheet - modal bottom sheet for adding new items
/// 添加新物品表单 - 用于添加新物品的底部模态表单
class AddNewItemSheet extends StatefulWidget {
  const AddNewItemSheet({super.key});

  @override
  State<AddNewItemSheet> createState() => _AddNewItemSheetState();
}

class _AddNewItemSheetState extends State<AddNewItemSheet> {
  int _currentStep = 0;

  // Step 1: Ownership
  // 第 1 步：所有权
  bool? _isOwned;

  // Step 2: Usage Days
  // 第 2 步：使用天数
  final TextEditingController _daysUsedController = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();

  // Step 3: Item Details
  // 第 3 步：物品详情
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String? _selectedCategory;
  final _formKey3 = GlobalKey<FormState>();

  final List<String> _categories = [
    '实物',
    '订阅',
    '云服务/工具',
    '数码外设',
    '游戏娱乐',
    '音乐串流',
  ];

  @override
  void dispose() {
    _daysUsedController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              // 拖动手柄
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      '添加新物品',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Step progress
              // 步骤进度
              _buildStepIndicator(),

              // Step content
              // 步骤内容
              Expanded(
                child: _buildStepContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build step indicator
  /// 构建步骤指示器
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : isCompleted
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5)
                          : Theme.of(context).dividerColor,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (index < 2) ...[
                const SizedBox(width: 16),
                Container(
                  width: 32,
                  height: 3,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
                const SizedBox(width: 16),
              ],
            ],
          );
        }),
      ),
    );
  }

  /// Build step content
  /// 构建步骤内容
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  /// Step 1: Ownership Question
  /// 第 1 步：所有权问题
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '这是愿望清单还是已经买了？',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isOwned = true;
                _currentStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
            ),
            child: const Text(
              '已经买了',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isOwned = false;
                _currentStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
            ),
            child: const Text(
              '愿望清单',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2: Usage Days
  /// 第 2 步：使用天数
  Widget _buildStep2() {
    final isOwned = _isOwned ?? false;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isOwned ? '你已经用了多少天？' : '你预计买了之后用多少天？',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _daysUsedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isOwned ? '使用天数' : '预计使用天数',
                hintText: '输入天数',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入天数';
                }
                final days = int.tryParse(value);
                if (days == null || days <= 0) {
                  return '请输入有效的天数';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (isOwned) _buildPresetButton('今天刚买', '1'),
                _buildPresetButton('1年', '365'),
                _buildPresetButton('2年', '730'),
                _buildPresetButton('永久', '9999'),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 0;
                    });
                  },
                  child: const Text('上一步'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey2.currentState?.validate() ?? false) {
                      setState(() {
                        _currentStep = 2;
                      });
                    }
                  },
                  child: const Text('下一步'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build preset button
  /// 构建预设按钮
  Widget _buildPresetButton(String label, String value) {
    return OutlinedButton(
      onPressed: () {
        _daysUsedController.text = value;
      },
      child: Text(label),
    );
  }

  /// Step 3: Item Details
  /// 第 3 步：物品详情
  Widget _buildStep3() {
    final days = int.tryParse(_daysUsedController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final dailyCost = days > 0 ? price / days : 0.0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category picker
                  // 分类选择器
                  const Text(
                    '分类',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Price input
                  // 价格输入
                  TextFormField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '价格',
                      hintText: '输入价格',
                      prefixText: '¥',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入价格';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return '请输入有效的价格';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Name input
                  // 名称输入
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '名称',
                      hintText: '输入物品名称',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入名称';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description input (optional)
                  // 描述输入（可选）
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: '描述（可选）',
                      hintText: '输入物品描述',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link input (optional)
                  // 链接输入（可选）
                  TextFormField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      labelText: '链接（可选）',
                      hintText: '输入购买链接或相关网址',
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Real-time preview box
        // 实时预览框
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '预计日耗',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '¥${dailyCost.toStringAsFixed(2)}/天',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: dailyCost > 0
                                    ? (dailyCost < 10
                                        ? Colors.green
                                        : dailyCost < 30
                                            ? Colors.orange
                                            : Colors.red)
                                    : Colors.grey,
                              ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isCategoryValid() ? _saveItem : null,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Check if category is selected
  /// 检查是否选择了分类
  bool _isCategoryValid() {
    return _selectedCategory != null;
  }

  /// Save item
  /// 保存物品
  void _saveItem() {
    if (!(_formKey3.currentState?.validate() ?? false)) {
      return;
    }

    final vm = context.read<AddNewItemViewModel>();
    // TODO: Implement save logic in ViewModel
    // TODO：在 ViewModel 中实现保存逻辑

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功！')),
    );

    Navigator.pop(context);
  }
}
