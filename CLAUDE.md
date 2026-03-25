# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

All commands run from `life_cost_tracker/` subdirectory. Flutter binary is at `/Users/yuan/flutter/bin/flutter`.

```bash
cd life_cost_tracker
flutter pub get              # Install dependencies
flutter run                  # Debug mode on connected device
flutter run --release        # Release mode
flutter analyze              # Static analysis
flutter test                 # Run all tests
flutter test test/domain/entities/recurring_cost_test.dart  # Single test file
flutter build ipa --release --no-codesign  # iOS archive (no signing)
flutter build apk --release  # Android APK
```

iOS-specific: requires full Xcode + CocoaPods (`brew install cocoapods`). Open `ios/Runner.xcworkspace` for signing/provisioning.

## Architecture

Clean Architecture + MVVM with Provider. Three layers, strict dependency direction (presentation → domain ← data):

- **domain/** — Entities, repository interfaces, use cases. Framework-independent.
- **data/** — Hive TypeAdapters and repository implementations.
- **presentation/** — Views (Flutter widgets) and ViewModels (ChangeNotifier).

DI is manual in `main.dart`: Hive boxes → repositories → use cases → ViewModels via MultiProvider.

## Key Domain Concepts

### Dual-Cycle Billing Model
Every `RecurringCost` has two cycles:
- **basePeriod**: How the user *thinks* about it ("月租4500")
- **billingCycle**: How often they actually *pay* ("每季度付一次")
- `paymentAmount = amount × billingCycle.multiplierFrom(basePeriod)`
- `dailyCost = amount / basePeriod.daysInCycle` (uses actual calendar days, not fixed 30/365)

### Burn Rate vs Payment Tracking
Critical distinction:
- **Burn rate** (`totalDailyCost`): All `isActive=true` items, regardless of payment status. Only `isActive=false` excludes an item.
- **Payment tracking** (`isPaidForCurrentPeriod`, `paidItems/unpaidItems`): UI-only, for due date reminders and progress cards. Never affects burn rate calculation.

### Category System
Two-level hierarchy in `cost_category.dart`:
- 8 `CostCategoryGroup` enums (housing, transport, living, communication, digitalSubscription, healthCare, education, other)
- 26 `CostCategory` enums, each mapped to a group via `.group` property
- Each has `displayName`, `icon`, `color`

## Hive Persistence

TypeAdapters are manually written (not generated) with fixed typeIds starting at 10:
- `RecurringCostAdapter` (10), `CostCategoryAdapter` (11), `InstallmentPlanAdapter` (12), `AffordabilityItemAdapter` (13), `BillingCycleAdapter` (14)

**Never change existing typeIds** — will corrupt user data. New adapters should use typeId 15+.

Three Hive boxes: `'recurring_costs'`, `'installment_plans'`, `'affordability_items'`.

All entities are immutable — use `copyWith()` for updates.

## Entities

- **RecurringCost**: Periodic expense with dual-cycle billing. Key fields: `amount`, `basePeriod`, `billingCycle`, `category`, `nextDueDate`, `isPaidForCurrentPeriod`.
- **InstallmentPlan**: Fixed-term payment plan. Key fields: `monthlyPayment`, `totalPeriods`, `paidPeriods`, `startDate`. Has `isPaidForCurrentMonth` and `isOverdue` computed properties.
- **AffordabilityItem**: "What if I buy this?" simulation input.
- **SleepCostSummary**: Aggregated dashboard data. Splits recurring items into paid/unpaid lists; includes installment tracking.
- **BillingCycle**: weekly/monthly/quarterly/yearly with `daysInCycle` using actual calendar days.
- **DisplayCycle**: User's preferred view granularity (daily/monthly/quarterly/yearly).

## UI Patterns

- Bottom sheet forms (`DraggableScrollableSheet`) for adding/editing items
- iOS numeric keyboard uses comma as decimal separator in zh locale — always parse with `replaceAll(',', '.')`
- Date pickers must call `FocusScope.of(context).unfocus()` + 200ms delay before `showDatePicker()` to avoid iOS keyboard crash
- `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` on scroll views for keyboard dismissal

## Project Language

Code comments, commit messages, and UI strings are in Chinese (zh-CN). Variable names and API are in English.
