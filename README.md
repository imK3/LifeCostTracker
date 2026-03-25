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

## iOS 真机部署

### 环境准备

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

### 安装到 iPhone（USB 连接）

```bash
cd life_cost_tracker
flutter run --release
```

### 打包 IPA（用于 AltStore 侧载）

```bash
cd life_cost_tracker

# 不签名打包（后续通过 AltStore 签名安装）
flutter build ipa --release --no-codesign

# 产物位置：build/ios/archive/Runner.xcarchive
```

### 通过 Xcode 安装

```bash
open ios/Runner.xcworkspace
```
1. 左上角选择 iPhone 设备
2. Signing & Capabilities → 选择你的 Apple ID Team
3. 点击 Run (▶)

### 首次运行注意

iPhone 上信任开发者证书：**设置 → 通用 → VPN与设备管理 → 信任**

### 免费签名说明

- 免费 Apple ID 签名有效期 **7 天**，过期需重新安装
- 同时最多签 **3 个 App**
- 推荐使用 [AltStore](https://altstore.io/) 自动续签
- 同一 Apple ID 重签不影响 App 数据

## License

MIT License

---
*Last updated: 2026-03-25*
