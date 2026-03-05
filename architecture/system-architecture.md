# System Architecture Design - LifeCostTracker

## 1. High-Level Architecture Overview
The app follows **Clean Architecture + MVVM** to ensure separation of concerns, testability, and maintainability.

### Architecture Layers
```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  (SwiftUI Views, ViewModels, Navigation)                │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                     Domain Layer                         │
│  (Use Cases, Entities, Repository Interfaces)           │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                          │
│  (Repositories, Core Data, Plaid API, iCloud)           │
└─────────────────────────────────────────────────────────┘
```

## 2. Core Entities (Domain Layer)
### 2.1 Expense
```swift
struct Expense: Identifiable {
    let id: UUID
    let amount: Decimal
    let category: ExpenseCategory
    let date: Date
    let notes: String?
    let receiptPhotoURL: URL?
    let estimatedUsageDays: Int? // For daily cost calculation (optional for one-time expenses)
    
    var dailyCost: Decimal? {
        guard let days = estimatedUsageDays, days > 0 else { return nil }
        return amount / Decimal(days)
    }
}

enum ExpenseCategory: String, CaseIterable {
    case food, transport, shopping, entertainment, utilities, other
    // Custom categories supported via user input
}
```

### 2.2 Credit Account
```swift
struct CreditAccount: Identifiable {
    let id: UUID
    let name: String
    let type: CreditAccountType // .creditCard, .loan, .installment
    let balance: Decimal
    let creditLimit: Decimal?
    let apr: Double?
    let dueDate: Date?
    let minimumPayment: Decimal?
}

enum CreditAccountType {
    case creditCard, personalLoan, studentLoan, installmentPlan
}
```

### 2.3 Subscription
```swift
struct Subscription: Identifiable {
    let id: UUID
    let name: String
    let cost: Decimal
    let billingCycle: BillingCycle // .monthly, .yearly, .weekly
    let nextBillingDate: Date
    let category: SubscriptionCategory
    let isFreeTrial: Bool
    let freeTrialEndDate: Date?
    
    var dailyCost: Decimal {
        switch billingCycle {
        case .weekly:
            return cost / 7
        case .monthly:
            return cost / 30
        case .yearly:
            return cost / 365
        }
    }
}

enum BillingCycle {
    case weekly, monthly, yearly
}

enum SubscriptionCategory: String, CaseIterable {
    case streaming, productivity, foodDelivery, fitness, news, other
}
```

### 2.4 Wishlist Item
```swift
struct WishlistItem: Identifiable {
    let id: UUID
    let name: String
    let description: String?
    let targetDate: Date?
    let totalCost: Decimal
    let estimatedUsageDays: Int? // For daily cost calculation
    let priority: Priority
    let photoURL: URL?
    let linkURL: URL?
    
    var dailyCost: Decimal? {
        // If target date is set, calculate daily savings needed
        if let target = targetDate, target > Date() {
            let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 1
            return totalCost / Decimal(max(days, 1))
        }
        // Otherwise, calculate daily ownership cost based on estimated usage
        if let usageDays = estimatedUsageDays, usageDays > 0 {
            return totalCost / Decimal(usageDays)
        }
        return nil
    }
}

enum Priority: Int, CaseIterable {
    case low = 1, medium = 2, high = 3
}
```

## 3. Use Cases (Domain Layer)
Key use cases that define the app's core functionality:
- `AddExpenseUseCase`
- `GetExpensesUseCase`
- `AddCreditAccountUseCase`
- `CalculateCreditUtilizationUseCase`
- `AddSubscriptionUseCase`
- `GetUpcomingObligationsUseCase` (subscriptions + credit payments)
- `AddWishlistItemUseCase`
- `CheckAffordabilityUseCase`
- `GenerateMonthlyReportUseCase`

### Daily Cost-Specific Use Cases
- `CalculateAverageDailyCostUseCase`: Computes the overall daily cost average across all items
- `CalculateDailyCostBreakdownUseCase`: Breaks down daily cost by category (subscriptions, installments, one-time)
- `GenerateDailyCostTrendUseCase`: Creates 7-day, 30-day, 90-day daily cost trend data
- `CheckWishlistDailyCostImpactUseCase`: Shows how a wishlist item affects the average daily cost
- `CompareWishlistDailyCostsUseCase`: Compares daily costs of multiple wishlist items for tradeoff analysis
- `CalculateWishlistDailySavingsTargetUseCase`: Computes daily savings needed for a wishlist item by target date

## 4. Data Layer Design
### 4.1 Local Data Source: Core Data
- **Managed Object Context**: Uses `NSPersistentCloudKitContainer` for iCloud sync (optional, premium feature)
- **Core Data Entities**: Map 1:1 to Domain Entities with transformers for `Decimal`, `Date`, etc.
- **Migration Plan**: Lightweight migrations for minor schema changes; heavyweight migrations for major changes

### 4.2 Remote Data Source: Plaid API
- **Purpose**: Automatic transaction sync for premium users
- **Endpoints Used**:
  - `/link/token/create`: Initialize Plaid Link
  - `/transactions/sync`: Fetch and sync transactions
  - `/accounts/get`: Get account balances
- **Security**: Store Plaid access tokens in Keychain

### 4.3 Repository Pattern
Each domain entity has a corresponding repository protocol and implementation:
- `ExpenseRepository` protocol + `CoreDataExpenseRepository` implementation
- `CreditAccountRepository` protocol + `CoreDataCreditAccountRepository` implementation
- `SubscriptionRepository` protocol + `CoreDataSubscriptionRepository` implementation
- `WishlistItemRepository` protocol + `CoreDataWishlistItemRepository` implementation

## 5. Presentation Layer Design
### 5.1 Key Screens & Navigation Flow
```
Onboarding → Home Dashboard
              ↓
         ┌────┴────┬──────────┬──────────┬──────────┐
         ↓         ↓          ↓          ↓          ↓
      Expenses  Credit      Subscriptions Wishlist  Reports
         ↓         ↓          ↓          ↓          ↓
      Add/Edit  Add/Edit   Add/Edit   Add/Edit    View Report
```

### 5.2 ViewModels
Each screen has a corresponding ViewModel that:
- Exposes `@Published` properties for the View to observe
- Uses Use Cases to fetch and manipulate data
- Handles user input and navigation logic

Example:
```swift
class HomeDashboardViewModel: ObservableObject {
    @Published var monthlySummary: MonthlySummary?
    @Published var upcomingObligations: [Obligation] = []
    @Published var creditHealthSnapshot: CreditHealthSnapshot?

    private let getMonthlySummaryUseCase: GetMonthlySummaryUseCase
    private let getUpcomingObligationsUseCase: GetUpcomingObligationsUseCase
    private let getCreditHealthSnapshotUseCase: GetCreditHealthSnapshotUseCase

    // Initializer with dependency injection
    // Methods to load data
}
```

## 6. Security Architecture
### 6.1 Data Encryption
- **At Rest**: Core Data uses file protection (`NSFileProtectionCompleteUntilFirstUserAuthentication`)
- **Keychain**: All sensitive data (Plaid tokens, passwords) stored in Keychain with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`
- **Network**: TLS 1.3 for all Plaid API calls

### 6.2 Authentication
- **Biometric Login**: Uses `LocalAuthentication` framework for Face ID/Touch ID
- **Auto-Lock**: App locks after 5 minutes of inactivity (user-configurable)

## 7. Backup & Restore
- **iCloud Backup**: Uses `NSPersistentCloudKitContainer` to sync Core Data to iCloud (premium feature)
- **Manual Export**: User can export all data as CSV/PDF at any time
