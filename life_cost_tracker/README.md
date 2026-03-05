# LifeCostTracker - Flutter App Source Code

本文件夹包含 LifeCostTracker Flutter 应用的源代码。

## Project Structure
```
life_cost_tracker/
├── lib/
│   ├── domain/
│   │   ├── entities/          # Domain entities (business models)
│   │   ├── usecases/          # Use cases (business logic)
│   │   └── repositories/      # Repository interfaces (abstractions)
│   ├── data/
│   │   ├── datasources/       # Data sources (local/remote)
│   │   └── repositories/      # Repository implementations
│   └── presentation/
│       ├── views/             # Flutter UI screens
│       ├── viewmodels/        # ViewModels (MVVM)
│       └── widgets/           # Reusable Flutter widgets
└── test/
    └── domain/
        └── entities/          # Unit tests for domain entities
```

## Project Structure
```
life_cost_tracker/
├── lib/
│   ├── domain/
│   │   ├── entities/          # Domain entities (business models)
│   │   ├── usecases/          # Use cases (business logic)
│   │   └── repositories/      # Repository interfaces (abstractions)
│   ├── data/
│   │   ├── datasources/       # Data sources (local/remote)
│   │   └── repositories/      # Repository implementations
│   └── presentation/
│       ├── views/             # Flutter UI screens
│       ├── viewmodels/        # ViewModels (MVVM)
│       └── widgets/           # Reusable Flutter widgets
└── test/
    └── domain/
        └── entities/          # Unit tests for domain entities
```

## 当前进度
### Domain Layer
- ✅ **Entities**: Expense, CreditAccount, Subscription, WishlistItem (all complete)
- ✅ **Repository Interfaces**: ExpenseRepository, CreditAccountRepository, SubscriptionRepository, WishlistItemRepository (all complete)
- ✅ **Use Cases**: 13/16 complete (core business logic)

### Data Layer
- 🔄 **进行中**: Repository implementations, data sources

### Presentation Layer
- ⏳ **待完成**: ViewModels, Flutter UI screens

### Testing
- ✅ **Unit Tests**: Expense, CreditAccount, Subscription (3/4 complete)

## Getting Started
### 前置要求
- Flutter 3.16+
- Dart 3.0+

### 设置
1. 进入此文件夹
2. 运行 `flutter pub get` 安装依赖
3. 运行 `flutter run` 启动应用

## 说明
这是一个正在进行的工作。核心领域层已基本完成，但数据层和表现层仍在构建中。
