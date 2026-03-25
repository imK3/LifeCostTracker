# 开发文档

## 环境准备

```bash
# 安装 CocoaPods
brew install cocoapods

# 配置 Xcode（需要完整版 Xcode，非 Command Line Tools）
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# 下载 iOS SDK（如果 Xcode 缺少 iOS 平台）
xcodebuild -downloadPlatform iOS

# 验证环境
flutter doctor
```

## 开发运行

```bash
cd life_cost_tracker
flutter pub get
flutter run                  # Debug 模式（支持热重载）
flutter run --release        # Release 模式
flutter analyze              # 静态分析
flutter test                 # 运行测试
```

## iOS 真机部署

### 通过命令行

```bash
cd life_cost_tracker
flutter run --release
```

### 通过 Xcode

```bash
open ios/Runner.xcworkspace
```
1. 左上角选择 iPhone 设备
2. Signing & Capabilities → 选择你的 Apple ID Team
3. 点击 Run (▶)

### 打包 IPA（用于 AltStore 侧载）

```bash
cd life_cost_tracker
flutter build ipa --release --no-codesign
# 产物位置：build/ios/archive/Runner.xcarchive
```

### 首次运行

iPhone 上信任开发者证书：**设置 → 通用 → VPN与设备管理 → 信任**

### 免费签名说明

- 免费 Apple ID 签名有效期 **7 天**，过期需重新安装
- 同时最多签 **3 个 App**
- 推荐使用 [AltStore](https://altstore.io/) 自动续签
- 同一 Apple ID 重签不影响 App 数据

## 项目结构

```
life_cost_tracker/lib/
├── domain/
│   ├── entities/          # 业务实体
│   │   ├── recurring_cost.dart      # 周期性支出
│   │   ├── installment_plan.dart    # 分期承诺
│   │   ├── sleep_cost_summary.dart  # 汇总数据
│   │   ├── billing_cycle.dart       # 账单周期
│   │   ├── cost_category.dart       # 分类体系（8大类+26子分类）
│   │   ├── display_cycle.dart       # 展示周期
│   │   ├── date_utils.dart          # 安全日期计算
│   │   └── affordability_item.dart  # 模拟器项
│   ├── repositories/      # 仓库接口
│   └── usecases/          # 业务用例
├── data/
│   ├── adapters/          # Hive TypeAdapters（typeId 10+）
│   └── repositories/      # Hive 仓库实现
└── presentation/
    ├── viewmodels/        # ChangeNotifier ViewModels
    └── views/             # Flutter UI
        ├── home_dashboard_view.dart      # 首页
        ├── payment_calendar_view.dart    # 缴费日历
        ├── affordability_simulator_view.dart  # 承担能力模拟
        ├── happiness_research_page.dart  # 幸福感研究
        ├── cost_item_detail_view.dart    # 详情/编辑
        ├── add_cost_item_sheet.dart      # 添加表单
        ├── settings_view.dart            # 设置
        └── main_navigation.dart          # 底部导航
```

## 关键设计

### 双周期账单模型

- `basePeriod`：用户心智周期（如"月租4500"）
- `billingCycle`：实际付款周期（如"每季度付一次"）
- `paymentAmount = amount × billingCycle.multiplierFrom(basePeriod)`

### 自动推进规则

到期日过后自动视为已缴，nextDueDate 推进到下一期。提前手动标记已缴不影响后续计划。

### Hive TypeId 分配

| TypeId | 实体 |
|--------|------|
| 10 | RecurringCostAdapter |
| 11 | CostCategoryAdapter |
| 12 | InstallmentPlanAdapter |
| 13 | AffordabilityItemAdapter |
| 14 | BillingCycleAdapter |

**永远不要改已有 typeId**，新增从 15 开始。
