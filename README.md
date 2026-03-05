# LifeCostTracker - Personal Finance App

> **一个可以控制自己剁手欲望的 app** - 通过每日成本视角来管理财务

## Project Overview
LifeCostTracker is a personal finance tracking **Flutter application** (iOS + Android) focused on credit life management, subscriptions, installments, and wishlist planning.

**核心理念**: ¥7/day feels manageable. ¥2,500 feels heavy.

---

## 项目概览
LifeCostTracker 是一个专注于信用生活管理、订阅、分期付款和愿望清单规划的 **Flutter 应用**（iOS + Android）。

**核心理念**: ¥7/天 感觉可以接受。¥2,500 感觉压力很大。

## Key Features
- 💰 **Daily Cost Perspective**: Every expense is broken down into daily cost
- 💳 **Credit Life Management**: Track credit cards, loans, and installments
- 📱 **Subscription Management**: Track all subscriptions in one place
- 🎯 **Wishlist Planning**: Visualize how purchases affect your daily budget
- 📊 **Cost-Benefit Analysis**: "神仙性价比" ratings for smart spending

---

## 核心功能
- 💰 **每日成本视角**: 每笔支出都分解为每日成本
- 💳 **信用生活管理**: 追踪信用卡、贷款和分期付款
- 📱 **订阅管理**: 在一个地方追踪所有订阅
- 🎯 **愿望清单规划**: 可视化购买如何影响你的每日预算
- 📊 **成本效益分析**: "神仙性价比"评级，帮助明智消费

## Tech Stack
- **Framework**: Flutter 3.16+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL)
- **Secure Storage**: flutter_secure_storage
- **Charts**: fl_chart
- **Target Platforms**: iOS 14.0+, Android 6.0+ (API 23+)

---

## 技术栈
- **框架**: Flutter 3.16+
- **语言**: Dart 3.0+
- **状态管理**: Provider
- **本地存储**: Hive (NoSQL)
- **安全存储**: flutter_secure_storage
- **图表**: fl_chart
- **目标平台**: iOS 14.0+, Android 6.0+ (API 23+)

## Architecture
**Clean Architecture + MVVM**:
- **Domain Layer**: Entities, Use Cases, Repository Interfaces
- **Data Layer**: Repository Implementations, Data Sources
- **Presentation Layer**: Flutter Widgets, ViewModels

---

## 架构
**Clean Architecture + MVVM**:
- **领域层**: 实体、用例、仓库接口
- **数据层**: 仓库实现、数据源
- **表现层**: Flutter Widgets、ViewModels

## Project Structure
```
LifeCostTracker/
├── PLAN.md                          # Overall project plan with task list
├── README.md                        # This file
├── market-research/
│   └── market-analysis.md           # Market research and competitor analysis
├── requirements/
│   ├── functional-requirements.md   # Functional requirements
│   └── non-functional-requirements.md # Non-functional requirements
├── architecture/
│   ├── tech-stack.md                # Tech stack selection
│   └── system-architecture.md       # System architecture design
├── ui-ux/
│   └── ui-ux-design.md              # UI/UX design guidelines
├── project-management/
│   ├── milestones.md                 # Project milestones and timeline
│   └── risk-assessment.md            # Risk assessment and mitigation
└── life_cost_tracker/               # Flutter app source code
    └── lib/
        ├── domain/
        │   ├── entities/            # Domain entities (Expense, CreditAccount, etc.)
        │   ├── usecases/            # Use cases (business logic)
        │   └── repositories/        # Repository interfaces
        ├── data/
        │   ├── datasources/         # Data sources (local/remote)
        │   └── repositories/        # Repository implementations
        └── presentation/
            ├── views/               # Flutter UI screens
            ├── viewmodels/          # ViewModels
            └── widgets/             # Reusable widgets
    └── test/
        └── domain/
            └── entities/            # Unit tests for domain entities
```

---

## 项目结构
```
LifeCostTracker/
├── PLAN.md                          # 总体项目计划（含任务列表）
├── README.md                        # 本文档
├── market-research/
│   └── market-analysis.md           # 市场研究和竞品分析
├── requirements/
│   ├── functional-requirements.md   # 功能需求
│   └── non-functional-requirements.md # 非功能需求
├── architecture/
│   ├── tech-stack.md                # 技术栈选型
│   └── system-architecture.md       # 系统架构设计
├── ui-ux/
│   └── ui-ux-design.md              # UI/UX 设计指南
├── project-management/
│   ├── milestones.md                 # 项目里程碑和时间线
│   └── risk-assessment.md            # 风险评估和缓解
└── life_cost_tracker/               # Flutter 应用源代码
    └── lib/
        ├── domain/
        │   ├── entities/            # 领域实体（Expense、CreditAccount 等）
        │   ├── usecases/            # 用例（业务逻辑）
        │   └── repositories/        # 仓库接口
        ├── data/
        │   ├── datasources/         # 数据源（本地/远程）
        │   └── repositories/        # 仓库实现
        └── presentation/
            ├── views/               # Flutter UI 页面
            ├── viewmodels/          # ViewModels
            └── widgets/             # 可复用组件
    └── test/
        └── domain/
            └── entities/            # 领域实体单元测试
```

## Progress
- **Phase 1-5**: ✅ Complete (Planning, Research, Requirements, Architecture, UI/UX)
- **Phase 6**: ✅ Complete (Git Repository Setup)
- **Phase 7**: 🔄 In Progress (Domain Layer Implementation)
  - ✅ Core Entities (9/9)
  - ✅ Repository Interfaces (4/4)
  - ✅ Use Cases (13/16)
- **Phase 12**: 🔄 In Progress (Testing)
  - ✅ Unit Tests for Domain Entities (3/4)

---

## 进度
- **阶段 1-5**: ✅ 已完成（规划、研究、需求、架构、UI/UX）
- **阶段 6**: ✅ 已完成（Git 仓库设置）
- **阶段 7**: 🔄 进行中（领域层实现）
  - ✅ 核心实体 (9/9)
  - ✅ 仓库接口 (4/4)
  - ✅ 用例 (13/16)
- **阶段 12**: 🔄 进行中（测试）
  - ✅ 领域实体单元测试 (3/4)

## Getting Started
### Prerequisites
- Flutter 3.16+
- Dart 3.0+
- Xcode 15+ (for iOS development)
- Android Studio Hedgehog+ (for Android development)

### Setup
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

---

## 开始使用
### 前置要求
- Flutter 3.16+
- Dart 3.0+
- Xcode 15+（用于 iOS 开发）
- Android Studio Hedgehog+（用于 Android 开发）

### 设置
1. 克隆仓库
2. 运行 `flutter pub get` 安装依赖
3. 运行 `flutter run` 启动应用

## GitHub Repository
https://github.com/imK3/LifeCostTracker

## License
MIT License

---
*Last updated: 2026-03-05*
