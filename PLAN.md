# LifeCostTracker - Personal Finance App Project Plan

## Project Overview
一个可以控制自己剁手欲望的 app - 通过每日成本视角来管理财务。

**核心理念**: ¥7/day feels manageable. ¥2,500 feels heavy.

---

## Phase 1: Market & User Research ✅
- [x] Analyze existing personal finance apps (market research)
- [x] Define target user personas
- [x] Identify key pain points and unique value propositions

## Phase 2: Requirements Definition ✅
- [x] Functional requirements (features list)
- [x] Non-functional requirements (performance, security, UX)
- [x] Tech stack selection (iOS specific)

## Phase 3: System Architecture Design ✅
- [x] High-level system architecture diagram
- [x] Database schema design (Core Data)
- [x] API design (Plaid integration)
- [x] iOS app architecture (Clean Architecture + MVVM)

## Phase 4: UI/UX Design ✅
- [x] Wireframes for key screens (described in ui-ux-design.md)
- [x] User flow diagrams
- [x] Visual design guidelines (color palette, typography)

## Phase 5: Project Management Setup ✅
- [x] Define development milestones
- [x] Risk assessment and mitigation plan
- [x] Project folder structure created
- [x] Set up OpenClaw cron job to monitor task completion

---

## Phase 6: Project Initialization & Setup (进行中)
### 6.1 Git Repository Setup ✅
- [x] Initialize local git repository
- [x] Create .gitignore file for Flutter project
- [x] Add remote origin: https://github.com/imK3/LifeCostTracker
- [x] Initial commit with all planning documents
- [x] Push to GitHub main branch

### 6.2 Flutter Project Setup
- [ ] Create new Flutter project (`flutter create life_cost_tracker`)
- [ ] Configure project settings (app name, bundle identifier, deployment targets)
- [ ] Set up Clean Architecture folder structure
- [ ] Add pubspec.yaml dependencies (provider, hive, flutter_secure_storage, dio, cached_network_image, fl_chart, intl, etc.)
- [ ] Initialize Hive database
- [ ] Set up Firebase Crashlytics (optional, cross-platform)
- [ ] Set up Firebase Analytics (optional, cross-platform)

---

## Phase 7: Domain Layer Implementation (进行中)
### 7.1 Core Entities (Swift version deprecated, switching to Flutter/Dart)
- [x] Create Expense entity (Swift version, deprecated)
- [x] Create ExpenseCategory enum (Swift version, deprecated)
- [x] Create CreditAccount entity (Swift version, deprecated)
- [x] Create CreditAccountType enum (Swift version, deprecated)
- [x] Create Subscription entity (Swift version, deprecated)
- [x] Create BillingCycle enum (Swift version, deprecated)
- [x] Create SubscriptionCategory enum (Swift version, deprecated)
- [x] Create WishlistItem entity (Swift version, deprecated)
- [x] Create Priority enum (Swift version, deprecated)

### 7.1 Core Entities (Flutter/Dart version) ✅
- [x] Create Expense entity (with estimatedUsageDays, dailyCost computed property)
- [x] Create ExpenseCategory enum
- [x] Create CreditAccount entity
- [x] Create CreditAccountType enum
- [x] Create Subscription entity (with dailyCost computed property)
- [x] Create BillingCycle enum
- [x] Create SubscriptionCategory enum
- [x] Create WishlistItem entity (with dailyCost computed property)
- [x] Create Priority enum

### 7.2 Use Cases (进行中)
- [x] Create BaseUseCase
- [x] Create AddExpenseUseCase
- [x] Create GetExpensesUseCase
- [x] Create AddCreditAccountUseCase
- [x] Create CalculateCreditUtilizationUseCase
- [x] Create AddSubscriptionUseCase
- [ ] Create GetUpcomingObligationsUseCase
- [ ] Create AddWishlistItemUseCase
- [ ] Create CheckAffordabilityUseCase
- [ ] Create GenerateMonthlyReportUseCase
- [ ] Create CalculateAverageDailyCostUseCase
- [ ] Create CalculateDailyCostBreakdownUseCase
- [ ] Create GenerateDailyCostTrendUseCase
- [ ] Create CheckWishlistDailyCostImpactUseCase
- [ ] Create CompareWishlistDailyCostsUseCase
- [ ] Create CalculateWishlistDailySavingsTargetUseCase

### 7.3 Repository Interfaces ✅
- [x] Create ExpenseRepository protocol
- [x] Create CreditAccountRepository protocol
- [x] Create SubscriptionRepository protocol
- [x] Create WishlistItemRepository protocol

---

## Phase 8: Data Layer Implementation
### 8.1 Core Data Model
- [ ] Create Expense Core Data entity
- [ ] Create CreditAccount Core Data entity
- [ ] Create Subscription Core Data entity
- [ ] Create WishlistItem Core Data entity
- [ ] Create Value Transformers for Decimal, Date, etc.
- [ ] Set up Core Data model relationships
- [ ] Configure NSPersistentCloudKitContainer (optional, for iCloud sync)

### 8.2 Repository Implementations
- [ ] Create CoreDataExpenseRepository (implement ExpenseRepository)
- [ ] Create CoreDataCreditAccountRepository (implement CreditAccountRepository)
- [ ] Create CoreDataSubscriptionRepository (implement SubscriptionRepository)
- [ ] Create CoreDataWishlistItemRepository (implement WishlistItemRepository)

### 8.3 Plaid Integration (Premium Feature)
- [ ] Create Plaid API client
- [ ] Implement /link/token/create endpoint
- [ ] Implement /transactions/sync endpoint
- [ ] Implement /accounts/get endpoint
- [ ] Create PlaidAccessToken storage in Keychain
- [ ] Create transaction sync use case

### 8.4 Keychain Integration
- [ ] Create Keychain helper class
- [ ] Implement secure storage for Plaid tokens
- [ ] Implement secure storage for authentication tokens

---

## Phase 9: Presentation Layer - ViewModels
### 9.1 Home Dashboard ViewModel
- [ ] Create HomeDashboardViewModel
- [ ] Implement @Published properties for monthlySummary
- [ ] Implement @Published properties for upcomingObligations
- [ ] Implement @Published properties for creditHealthSnapshot
- [ ] Implement @Published properties for averageDailyCost
- [ ] Implement @Published properties for dailyCostBreakdown
- [ ] Implement data loading methods
- [ ] Implement dependency injection for use cases

### 9.2 All Items List ViewModel
- [ ] Create AllItemsListViewModel
- [ ] Implement @Published properties for items array
- [ ] Implement sorting logic (按性价比 / 按日耗 / 按分类)
- [ ] Implement filter logic (实物 / 订阅 / 云服务/工具 / 等)
- [ ] Implement 性价比 tier grouping

### 9.3 Add New Item ViewModel
- [ ] Create AddNewItemViewModel
- [ ] Implement ownership question logic (愿望清单 vs 已经买了)
- [ ] Implement usage days input with presets
- [ ] Implement real-time daily cost preview
- [ ] Implement category selection
- [ ] Implement validation logic
- [ ] Implement save method

### 9.4 Item Detail ViewModel
- [ ] Create ItemDetailViewModel
- [ ] Implement item details display
- [ ] Implement daily cost trend chart data
- [ ] Implement edit functionality
- [ ] Implement delete functionality
- [ ] Implement mark as sold/gone functionality

### 9.5 Other ViewModels
- [ ] Create ReportsViewModel
- [ ] Create SettingsViewModel

---

## Phase 10: Presentation Layer - Views
### 10.1 Home Dashboard View
- [ ] Create HomeDashboardView
- [ ] Implement Top Hero Section (3-column layout)
  - [ ] 平均每日成本 display
  - [ ] 月度订阅支出 display
  - [ ] 全部项目 display
- [ ] Implement Sorting Toggle (按性价比 / 按日耗 / 按分类)
- [ ] Implement All Items List
  - [ ] 神仙性价比 section with gradient
  - [ ] Item card layout (left: labels, middle: name/details, right: daily cost)
  - [ ] Section dividers between 性价比 tiers
- [ ] Implement Filter Button
- [ ] Implement Floating Action Button (FAB)

### 10.2 Add New Item Sheet
- [ ] Create AddNewItemSheet
- [ ] Implement Step 1: Ownership Question (two big buttons)
- [ ] Implement Step 2: Usage Days Input (with presets)
- [ ] Implement Step 3: All Cases (category, price, name, description)
- [ ] Implement Photo/Link attachment
- [ ] Implement Real-time Preview Box (live daily cost calculation)
- [ ] Implement Save Button (disabled until valid)

### 10.3 Item Detail View
- [ ] Create ItemDetailView
- [ ] Implement Top Hero Section (item name, daily cost, total cost, labels)
- [ ] Implement History & Stats section
  - [ ] Daily cost trend chart
  - [ ] Usage statistics and insights
- [ ] Implement Actions section
  - [ ] Edit button
  - [ ] Mark as Sold/Gone button
  - [ ] Move to Wishlist/Owned button
  - [ ] Delete button (red, at bottom)

### 10.4 Other Views
- [ ] Create ReportsView
- [ ] Create SettingsView
- [ ] Create OnboardingView (Welcome, First Item Tutorial, Dashboard Reveal)

---

## Phase 11: UI/UX Polish
### 11.1 Design System
- [ ] Implement Color Palette (Primary Blue, Success Green, Warning Orange, Danger Red, 神仙性价比 Gradient)
- [ ] Implement Typography (SF Pro Display, SF Pro Text, SF Mono)
- [ ] Create reusable components (ItemCard, LabelPill, PreviewBox, etc.)

### 11.2 Dark Mode
- [ ] Test all screens in Dark Mode
- [ ] Adjust 神仙性价比 gradient for Dark Mode
- [ ] Ensure charts and visualizations are readable

### 11.3 Accessibility
- [ ] Add accessibility labels to all interactive elements
- [ ] Implement Dynamic Type support
- [ ] Test VoiceOver for all key user flows
- [ ] Implement Reduce Motion support
- [ ] Ensure high contrast colors
- [ ] Avoid color-only indicators

### 11.4 Animations
- [ ] Add subtle animations for card transitions
- [ ] Add animations for sorting/filtering changes
- [ ] Add confetti animation for "神仙性价比" items?

---

## Phase 12: Testing (进行中)
### 12.1 Unit Tests (进行中)
- [x] Write unit tests for Expense entity
- [x] Write unit tests for CreditAccount entity
- [x] Write unit tests for Subscription entity
- [ ] Write unit tests for WishlistItem entity
- [ ] Write unit tests for Use Cases
- [ ] Write unit tests for ViewModels (80% coverage target)
- [ ] Write unit tests for Repository implementations

### 12.2 UI Tests
- [ ] Write UI tests for Home Dashboard flow
- [ ] Write UI tests for Add New Item flow
- [ ] Write UI tests for Item Detail flow
- [ ] Write UI tests for Onboarding flow

### 12.3 Beta Testing
- [ ] Set up TestFlight
- [ ] Invite 10-20 internal beta testers
- [ ] Collect feedback
- [ ] Fix bugs and make improvements

---

## Phase 13: App Store Preparation
### 13.1 App Store Listing
- [ ] Write app description
- [ ] Create screenshots (iPhone SE, iPhone 16 Pro Max)
- [ ] Create app preview video (optional)
- [ ] Choose keywords
- [ ] Set up age rating
- [ ] Set up pricing and availability

### 13.2 Legal & Compliance
- [ ] Create Privacy Policy
- [ ] Create Terms of Service
- [ ] Ensure compliance with App Store guidelines
- [ ] Ensure compliance with GDPR/CCPA (if applicable)

### 13.3 Final Build
- [ ] Archive final build in Xcode
- [ ] Submit to App Store
- [ ] Wait for review
- [ ] Address any review feedback
- [ ] Launch!

---

## Progress Tracking
- **Last Updated**: 2026-03-05
- **Total Tasks**: ~150
- **Completed Tasks**: 18 (Phase 1-5)
- **Current Phase**: Phase 6: Project Initialization & Setup

---

*Note: This plan will be updated as tasks are completed. The OpenClaw cron job checks every 5 minutes and reports progress.*
