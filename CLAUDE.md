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
- `dailyCost = amount / basePeriod.daysInCycle` (uses actual calendar days)

### Auto-Advance Rule
When `nextDueDate` is in the past, `CalculateSleepCostUseCase` auto-advances it to the next period (persisted to Hive). Users can manually mark as paid early; the schedule continues unchanged.

### Burn Rate vs Payment Tracking
- **Burn rate** (`totalDailyCost`): All `isActive=true` items. `isActive=false` excludes. Payment status irrelevant.
- **Payment tracking** (`isPaidForCurrentPeriod`): UI-only for progress cards and due date reminders.

### Happiness Score
0-100 score based on fixed-cost-to-income ratio. Per-category health comparison against benchmarks. Defined in `SettingsViewModel`.

### Category System
Two-level hierarchy in `cost_category.dart`:
- 8 `CostCategoryGroup` enums (housing, transport, living, communication, digitalSubscription, healthCare, education, other)
- 26 `CostCategory` enums, each mapped to a group via `.group` property

## Hive Persistence

TypeAdapters are manually written with fixed typeIds starting at 10:
- `RecurringCostAdapter` (10), `CostCategoryAdapter` (11), `InstallmentPlanAdapter` (12), `AffordabilityItemAdapter` (13), `BillingCycleAdapter` (14)

**Never change existing typeIds** — will corrupt user data. New adapters should use typeId 15+.

Four Hive boxes: `'recurring_costs'`, `'installment_plans'`, `'affordability_items'`, `'settings'`.

All entities are immutable — use `copyWith()` for updates.

## Date Arithmetic

Always use `safeDate()` and `addMonths()` from `date_utils.dart` instead of raw `DateTime(year, month + N, day)`. Dart handles month overflow (13 → Jan next year) but NOT day overflow (Feb 31 → Mar 3).

## Entities

- **RecurringCost**: Periodic expense with dual-cycle billing. Key: `amount`, `basePeriod`, `billingCycle`, `category`, `nextDueDate`, `isPaidForCurrentPeriod`.
- **InstallmentPlan**: Fixed-term payment plan. Key: `monthlyPayment`, `totalPeriods`, `paidPeriods`, `nextDueDate`, `isPaidForCurrentPeriod`. Same payment tracking semantics as RecurringCost.
- **AffordabilityItem**: Simulation input for "what if I buy this?".
- **SleepCostSummary**: Aggregated dashboard data. Splits items into paid/unpaid; computes monthly trackable counts excluding future months.

## UI Patterns

- Bottom sheet forms (`DraggableScrollableSheet`) for adding items
- iOS numeric keyboard uses comma as decimal separator in zh locale — always parse with `replaceAll(',', '.')`
- Date pickers must call `FocusScope.of(context).unfocus()` + 200ms delay before `showDatePicker()` to avoid iOS keyboard crash
- `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` on all scroll views
- Use `SettingsViewModel.dailyToMonthly(dailyCost)` for monthly display, never `dailyCost * 30`

## Navigation

4 tabs: 睡后成本 (dashboard) → 缴费日历 (calendar) → 模拟器 (simulator) → 设置 (settings)

Homepage left icon → happiness research page. Homepage hero card → income setting dialog.

## Project Language

Code comments, commit messages, and UI strings are in Chinese (zh-CN). Variable names and API are in English.
