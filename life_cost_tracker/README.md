# LifeCostTracker - Flutter App Source Code

This folder contains the Flutter application source code for LifeCostTracker.

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

## Current Progress
### Domain Layer
- ✅ **Entities**: Expense, CreditAccount, Subscription, WishlistItem (all complete)
- ✅ **Repository Interfaces**: ExpenseRepository, CreditAccountRepository, SubscriptionRepository, WishlistItemRepository (all complete)
- ✅ **Use Cases**: 13/16 complete (core business logic)

### Data Layer
- 🔄 **In Progress**: Repository implementations, data sources

### Presentation Layer
- ⏳ **Pending**: ViewModels, Flutter UI screens

### Testing
- ✅ **Unit Tests**: Expense, CreditAccount, Subscription (3/4 complete)

## Getting Started
### Prerequisites
- Flutter 3.16+
- Dart 3.0+

### Setup
1. Navigate to this folder
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Note
This is a work in progress. The core domain layer is mostly complete, but the data and presentation layers are still being built.
