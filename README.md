# LifeCostTracker - 睡后成本追踪器

> **每天醒来，你就欠了这么多钱** - 通过睡后成本视角管理个人财务

## 核心理念

"睡后收入"人人追求，但你知道你的**"睡后成本"**是多少吗？

每天睁开眼睛，房租、水电、订阅、分期……这些固定支出已经在消耗你的钱包。LifeCostTracker 帮你看清这个数字，并做出更理性的消费决策。

## 核心功能

- **睡后成本 Dashboard**: 醒来就看到今天/本月/今年的固定支出
- **三大成本分类**:
  - 固定生活成本（房租、水电、停车、伙食）
  - 订阅费用（Claude、iCloud、视频会员、话费）
  - 分期承诺（手机分期、贷款等有终点的还款）
- **承担能力模拟器**: "如果我买了这个，我的睡后成本会变成多少？"
- **灵活展示周期**: 按日/月/年查看成本
- **可视化**: 饼图展示成本结构，进度条追踪分期还款

## Tech Stack

- **Framework**: Flutter (iOS + Android + Web + macOS)
- **Language**: Dart 3.5+
- **Architecture**: Clean Architecture + MVVM
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL)
- **Charts**: fl_chart
- **Target Platforms**: iOS 14.0+, Android 6.0+

## Project Structure

```
life_cost_tracker/lib/
├── domain/
│   ├── entities/          # RecurringCost, InstallmentPlan, AffordabilityItem, SleepCostSummary
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # CalculateSleepCost, SimulateAffordability, CRUD use cases
├── data/
│   ├── adapters/          # Hive TypeAdapters
│   └── repositories/      # Hive repository implementations
└── presentation/
    ├── viewmodels/        # SleepCostDashboard, AddCostItem, AffordabilitySimulator, etc.
    └── views/             # Dashboard, AddCostItemSheet, Simulator, Settings, Detail
```

## Getting Started

```bash
git clone https://github.com/imK3/LifeCostTracker.git
cd LifeCostTracker/life_cost_tracker
flutter pub get
flutter run
```

## License

MIT License

---
*Last updated: 2026-03-12*
