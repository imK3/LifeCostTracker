# Architecture

This folder contains architecture design and tech stack selection for the LifeCostTracker project.

## Files
- `tech-stack.md`: Tech stack selection
- `system-architecture.md`: System architecture design

## Summary
### Tech Stack
- **Framework**: Flutter 3.16+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Storage**: Hive
- **Secure Storage**: flutter_secure_storage
- **Charts**: fl_chart
- **Target Platforms**: iOS 14.0+, Android 6.0+ (API 23+)

### Architecture
**Clean Architecture + MVVM**:
- **Presentation Layer**: Flutter Widgets + ViewModels
- **Domain Layer**: Use Cases, Entities, Repository Interfaces
- **Data Layer**: Repository Implementations, Local/Remote Data Sources

### Core Entities
- Expense
- CreditAccount
- Subscription
- WishlistItem
