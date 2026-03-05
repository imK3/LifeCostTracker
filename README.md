# LifeCostTracker - Personal Finance App

> **一个可以控制自己剁手欲望的 app** - 通过每日成本视角来管理财务

## Project Overview
LifeCostTracker is a personal finance tracking **Flutter application** (iOS + Android) focused on credit life management, subscriptions, installments, and wishlist planning.

**核心理念**: ¥7/day feels manageable. ¥2,500 feels heavy.

## Key Features
- 💰 **Daily Cost Perspective**: Every expense is broken down into daily cost
- 💳 **Credit Life Management**: Track credit cards, loans, and installments
- 📱 **Subscription Management**: Track all subscriptions in one place
- 🎯 **Wishlist Planning**: Visualize how purchases affect your daily budget
- 📊 **Cost-Benefit Analysis**: "神仙性价比" ratings for smart spending

## Tech Stack
- **Framework**: Flutter 3.16+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL)
- **Secure Storage**: flutter_secure_storage
- **Charts**: fl_chart
- **Target Platforms**: iOS 14.0+, Android 6.0+ (API 23+)

## Architecture
**Clean Architecture + MVVM**:
- **Domain Layer**: Entities, Use Cases, Repository Interfaces
- **Data Layer**: Repository Implementations, Data Sources
- **Presentation Layer**: Flutter Widgets, ViewModels

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

## Progress
- **Phase 1-5**: ✅ Complete (Planning, Research, Requirements, Architecture, UI/UX)
- **Phase 6**: ✅ Complete (Git Repository Setup)
- **Phase 7**: 🔄 In Progress (Domain Layer Implementation)
  - ✅ Core Entities (9/9)
  - ✅ Repository Interfaces (4/4)
  - ✅ Use Cases (13/16)
- **Phase 12**: 🔄 In Progress (Testing)
  - ✅ Unit Tests for Domain Entities (3/4)

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

## GitHub Repository
https://github.com/imK3/LifeCostTracker

## License
MIT License

---
*Last updated: 2026-03-05*
