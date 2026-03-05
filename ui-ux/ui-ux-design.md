# UI/UX Design - LifeCostTracker

## 1. Design Principles
- **Daily Cost First**: Every expense is presented as a daily cost first, total cost second
- **Clarity First**: Financial data can be overwhelming; prioritize readability and simplicity
- **Gentle Onboarding**: Start with manual entry to build trust before asking for bank sync
- **Positive Reinforcement**: Celebrate small wins (e.g., "You paid off an installment!")
- **Accessibility**: Design for all users, including those with visual impairments

### Core Design Mantra
> **"¥7/day feels manageable. ¥2,500 feels heavy."**  
> Every screen, every card, every number should reinforce this perspective shift.

## 2. Color Palette
### Primary Colors
- **Primary Blue**: #007AFF (trust, reliability)
- **Success Green**: #34C759 (good financial health, paid off)
- **Warning Orange**: #FF9500 (upcoming payments, high utilization)
- **Danger Red**: #FF3B30 (overdue payments, very high utilization)
- **神仙性价比 Gradient**: From #34C759 to #007AFF (for top tier items)

### Neutral Colors
- **Background**: System Background (supports Dark Mode)
- **Text**: Label, Secondary Label (system colors)
- **Cards**: System Grouped Background

## 3. Typography
- **Headings**: SF Pro Display (Bold/Heavy)
- **Body**: SF Pro Text (Regular/Medium)
- **Numbers**: SF Mono (for amounts, due dates)

## 4. Key Screens
### 4.1 Home Dashboard (Main Screen)
**Layout**: 
- **Top Hero Section** (fixed at top, 3 key metrics in a row)
- **Sorting Toggle** (below hero)
- **All Items List** (main scrollable content)

#### 1. Top Hero Section (3-column horizontal layout)
- **Left: 平均每日成本**
  - Large number: "119元/天" (font size: 36pt, bold, SF Mono)
  - Small subtitle: "平均每日成本" (SF Pro Text, Regular)
- **Middle: 月度訂閱支出**
  - Number: "45元/月" (font size: 24pt, bold)
  - Small subtitle: "1.5元/天" (daily conversion, lighter color)
- **Right: 全部項目**
  - Number: "6個項目" (font size: 24pt, bold)
  - Small subtitle with tiny icons: 实物 | 订阅 | 云服务/工具 | 数码外设 | 游戏娱乐 | 音乐串流

#### 2. Sorting Toggle (segmented control)
- Default selected: "按性价比" (highlighted in Primary Blue)
- Other options: "按日耗" | "按分类"
- SF Symbol icons next to each option
- Width: Full width of screen

#### 3. All Items List (main scrollable content)
Sorted by **"按性价比" by default**

**Section Structure**:
- **Section 1: 神仙性价比** (items with this label appear first)
  - Section header with gradient background matching the label
  - Items in this section have slightly elevated cards
- **Section 2: 超值**
- **Section 3: 一般**
- **Section 4: 不值得**

**Item Card Layout (each card)**:
- **Left Column**:
  - Top: 分类标签 (pill shape, small font): "数码外设" / "音乐串流" / "云服务/工具"
  - Bottom: 性价比标签 (pill shape, gradient for "神仙性价比"): "神仙性价比" / "超值" / "一般" / "不值得"
- **Middle Column**:
  - Top: Item name (bold, SF Pro Display): "Mac Mini M4"
  - Bottom: Metadata (small, Secondary Label): "¥3,499元 | 当前486天"
- **Right Column**:
  - **当前实际日耗** (large, bold, SF Mono, right-aligned): "7元"
  - Small subtitle (for subscriptions): "每日" or "年付"

**Example Cards**:
1. **Mac Mini M4**:
   - Left: "数码外设" + "神仙性价比" (gradient)
   - Middle: "Mac Mini M4" + "¥3,499元 | 当前486天"
   - Right: "7元"
2. **QQ音乐**:
   - Left: "音乐串流" + "神仙性价比"
   - Middle: "QQ音乐" + "¥79元 | 年付 | 当前1天"
   - Right: "0.2元"
3. **京东**:
   - Left: "云服务/工具" + "神仙性价比"
   - Middle: "京东" + "¥69元 | 年付 | 当前1天"
   - Right: "0.2元"

---

### 4.2 (No separate tabs - all items in one list with filters)
- **Filter Button**: Top right corner (SF Symbol: line.3.horizontal.decrease.circle)
  - Tap to open filter sheet
  - Filter options: 实物 / 订阅 / 云服务/工具 / 数码外设 / 游戏娱乐 / 音乐串流 / 全部
- **Add Button**: Floating Action Button (FAB) at bottom right: "+" (circular, Primary Blue)
  - Tap to open "Add New Item" sheet

---

### 4.3 Add New Item Sheet (Modal)
**Step 1: Ownership Question** (full screen, two big buttons)
- Title: "这是愿望清单还是已经买了？"
- Button 1 (left): "已经买了" (green)
- Button 2 (right): "愿望清单" (blue)

**Step 2: If "已经买了"**:
- Question 1: "你已经用了多少天？"
  - Text input with placeholder: "输入天数"
  - Shortcut button below: "今天刚买" (fills in "1")
- Question 2: "你预计总共用多少天？"
  - Text input with placeholder: "预计总使用天数"
  - Preset buttons: "1年" (365) / "2年" (730) / "永久" (9999)

**Step 2: If "愿望清单"**:
- Question 1: "你预计买了之后用多少天？"
  - Text input with placeholder: "预计使用天数"
  - Preset buttons: "1年" (365) / "2年" (730) / "永久" (9999)
- Question 2: "你打算什么时候买？"
  - Date picker
  - Preset buttons: "今天" / "1个月" / "3个月" / "1年"

**Step 3: All Cases**:
- Category picker (scrollable horizontal chips): 实物 / 订阅 / 云服务/工具 / 数码外设 / 游戏娱乐 / 音乐串流 / +自定义
- Price input (keyboard: decimal pad)
- Name input (text field)
- Description input (text view, optional)
- Photo/link attachment (optional)
- **Real-time Preview Box** (fixed at bottom):
  - As user types, shows live calculation: "预计日耗: ¥7/day"
  - Color-coded: Green = <10% of daily average, Orange = 10-30%, Red = >30%
- **Save Button**: Top right (disabled until required fields filled)

---

### 4.4 Item Detail Sheet (tap on any item card)
**Layout**: Vertical scroll
- **Top: Hero Section**
  - Item name (large, bold)
  - **当前实际日耗** (very large, SF Mono: "7元")
  - Total cost + usage days: "¥3,499 | 486天"
  - 性价比标签 + 分类标签
- **Middle: History & Stats**
  - Chart: Daily cost trend over time (if owned for >30 days)
  - "你已经用了 486 天，相当于省了 ¥xxx compared to buying disposable alternatives"
- **Bottom: Actions**
  - "Edit" button
  - "Mark as Sold/Gone" button (for owned items)
  - "Move to Wishlist" / "Move to Owned" button
  - "Delete" button (red, at very bottom)

---

## 5. Navigation
- **No Tab Bar**: Single screen with filters and sorting
- **Modal Sheets**: Used for adding/editing items, viewing item details, filters
- **Navigation Links**: Used for drilling into reports (if any)

## 6. Onboarding Flow
1. **Welcome Screen**: 
   - Big title: "一个可以控制自己剁手欲望的 app"
   - Subtitle: "Think in Days, Not in Yuan"
   - "Get Started" button
2. **First Item Tutorial**: 
   - "Let's add your first item to see how it works!"
   - Step-by-step guide to adding an item they own (e.g., their phone)
3. **Dashboard Reveal**: Show home dashboard with their first item
4. **Gentle Reminder**: "Remember: ¥7/day feels manageable. ¥2,500 feels heavy."

## 7. Dark Mode Support
- Fully support Dark Mode using system colors
- Test all screens in both Light and Dark modes
- Ensure charts and visualizations are readable in both modes
- "神仙性价比" gradient adjusts for Dark Mode

## 8. Accessibility Checklist
- [ ] All interactive elements have accessibility labels
- [ ] Dynamic Type support (font sizes up to 310%)
- [ ] VoiceOver works for all key user flows
- [ ] Reduce Motion support (disable animations if enabled)
- [ ] High contrast colors for text and backgrounds
- [ ] No color-only indicators (add icons/text)
- [ ] "当前实际日耗" is clearly announced by VoiceOver
