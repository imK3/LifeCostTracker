# Functional Requirements - LifeCostTracker

## 0. Core Concept: Daily Cost Perspective
Every expense—whether one-time, subscription, or installment—is automatically converted into a **daily cost** to help users make more intuitive financial decisions.

### Daily Cost Calculation Rules:
- **One-time purchases**: Total cost ÷ estimated usage days (user-configurable, default: 365 days for electronics, 30 days for consumables)
- **Subscriptions**: Monthly cost ÷ 30 days OR Yearly cost ÷ 365 days
- **Installments**: (Remaining balance + interest) ÷ remaining days
- **Wishlist items**: Total cost ÷ (target date - today)

### Key Daily Cost Metrics:
- **Average Daily Cost**: Total of all daily costs (rolling 30 days)
- **Daily Cost Breakdown**: By category (subscriptions, installments, one-time)
- **Daily Cost Trend**: 7-day, 30-day, 90-day trend lines

---

## 1. Core Features
### 1.1 Expense Tracking
- Manual entry of daily expenses (amount, category, notes, date)
- Optional photo attachment for receipts
- Basic categorization (Food, Transport, Shopping, etc.) with custom categories
- Quick-add templates for frequent expenses

### 1.2 Credit Life Management
- Credit card account management (balance, APR, due date, minimum payment)
- Installment plan tracking (total amount, remaining balance, monthly payment, number of payments left)
- Loan tracking (personal loans, student loans, etc.)
- Credit utilization percentage calculation
- Payment due date reminders

### 1.3 Subscription Management
- Add/edit/delete subscriptions (name, cost, billing cycle, next billing date)
- Subscription categorization (Streaming, Productivity, Food Delivery, etc.)
- Monthly/annual subscription cost summary
- Free trial tracking with expiration alerts
- Option to mark subscriptions for cancellation with reminder

### 1.4 Wishlist & Purchase Planning (for owned items too!)
- **All items** (wishlist AND owned) with:
  - Item name and description
  - Target purchase date (wishlist only)
  - Total cost
  - **Estimated usage duration** (in days, months, or years) for daily cost calculation
  - **Actual usage days tracked** (for owned items: "Current 486 days")
  - Priority (Low/Medium/High)
  - Links/photos
  - **Category tags**: 实物、订阅、云服务/工具、数码外设、游戏娱乐、音乐串流 (and custom categories)
  - **性价比标签**: "神仙性价比"、"超值"、"一般"、"不值得" (auto-calculated based on daily cost vs. usage)
- **Daily Cost Display**: 
  - Every item shows its daily cost prominently (e.g., "¥7/day")
  - **Owned items show "当前实际日耗"**: Based on actual usage days so far
  - **Example formats**: 
    - "Mac Mini M4 ¥3,499 | 当前486天 | 实际日耗 ¥7"
    - "QQ音乐 ¥79/年 | 每日 ¥0.2"
    - "京东 ¥69/年 | 每日 ¥0.2"
- **Sorting Options**:
  - "按性价比" (default): 神仙性价比 > 超值 > 一般 > 不值得
  - "按日耗": 从低到高或从高到低
  - "按分类": 实物、订阅、云服务/工具等
  - "按添加时间": 最新或最早
- **"Affordability Check" tool**: 
  - Shows how purchasing an item affects monthly budget
  - **Shows impact on Average Daily Cost** (e.g., "This will increase your daily cost by ¥7")
  - Compares to current daily cost average with color-coded indicator
- **Scenario planning**: 
  - Compare multiple wishlist items' impact on cash flow
  - **Compare daily cost tradeoffs** (e.g., "Choose between ¥7/day Mac Mini or ¥3/day AirPods")
- **Auto-generate savings plan** for high-priority items with daily savings target
- **"Wait, Do You Really Need This?" Check**: Before adding to wishlist, show comparison to daily cost of existing items

### 1.5 Dashboard & Reports
- **Home Dashboard**:
  - **Hero Section at Top**:
    - **平均每日成本**: "119元/天" (prominently displayed, large font)
    - **月度訂閱支出**: "45元/月" (with conversion to daily: "1.5元/天")
    - **全部項目**: "6個項目" (breakdown: 实物、订阅、云服务/工具、数码外设、游戏娱乐、音乐串流)
  - **Sorting Toggle**: "按性价比" (default) / "按日耗" / "按分类"
  - **Monthly summary** (income vs. expenses)
  - **Daily Cost Breakdown** (subscription vs. installment vs. one-time)
  - **Credit health snapshot** (utilization, upcoming payments)
  - **Upcoming subscriptions and installments** with daily cost
  - **Wishlist progress** with daily cost impact
- **All Items List View** (main screen below dashboard):
  - Default sort: "按性价比"
  - Each item card shows:
    - 性价比标签 (神仙性价比 / 超值 / 一般 / 不值得)
    - 分类标签 (实物 / 订阅 / 云服务/工具 / 数码外设 / 游戏娱乐 / 音乐串流)
    - Item name (e.g., "Mac Mini M4")
    - Total cost + actual usage days (e.g., "¥3,499元 | 当前486天")
    - **当前实际日耗** (prominently displayed: "7元")
- **Reports**:
  - Monthly expense breakdown (by category)
  - **Daily Cost Trend Report** (7-day, 30-day, 90-day trends)
  - Credit debt payoff projection with daily cost impact
  - Subscription cost trend (6 months) with daily cost view
  - Wishlist completion rate with daily cost savings
  - **"What If" Report**: Shows how daily cost changes with different purchase scenarios
  - **性价比分布报告**: Shows how many items fall into each 性价比 tier

## 2. User & Account Management
- User profile creation (name, email, password)
- Biometric login (Face ID/Touch ID)
- Data export (CSV, PDF)
- Data backup to iCloud
- Account deletion with data export option

## 3. Premium Features
- Automatic bank/credit card transaction sync (via Plaid or similar)
- Unlimited wishlist items
- Advanced scenario planning (multiple "what-if" scenarios)
- Custom report templates
- Priority customer support
