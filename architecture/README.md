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

---

# 架构设计

本文件夹包含 LifeCostTracker 项目的架构设计和技术栈选型。

## 文件
- `tech-stack.md`: 技术栈选型
- `system-architecture.md`: 系统架构设计

## 总结
### 技术栈
- **框架**: Flutter 3.16+
- **语言**: Dart 3.0+
- **状态管理**: Provider
- **本地存储**: Hive
- **安全存储**: flutter_secure_storage
- **图表**: fl_chart
- **目标平台**: iOS 14.0+、Android 6.0+ (API 23+)

### 架构
**Clean Architecture + MVVM**:
- **表现层**: Flutter Widgets + ViewModels
- **领域层**: 用例、实体、仓库接口
- **数据层**: 仓库实现、本地/远程数据源

### 核心实体
- Expense（支出）
- CreditAccount（信用账户）
- Subscription（订阅）
- WishlistItem（愿望清单项）
