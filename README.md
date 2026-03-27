<div align="center">

# LifeCostTracker

**这不是记账，这是你未来的账本**

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey?logo=apple)](https://www.apple.com/ios)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

看清你的固定支出全貌，掌控未来每一笔确定的花销

</div>

---

## 为什么做这个？

记账软件记录的是**过去** —— 钱花了才记一笔，然后呢？

但你的生活中有大量**已经确定的支出**：房租、保险、订阅、分期付款……这些钱不管你记不记，到期都得付。真正有意义的问题不是「上个月花了多少」，而是：

> **我到底背着多少周期性支出？什么时候要付？加起来有多大？**

LifeCostTracker 回答的就是这三个问题。它不看过去，只看未来 —— 把你所有确定要发生的支出铺开在面前，让你像编辑一本账本一样，**主动规划和调整**自己的固定开支结构。

少一笔订阅，每天省下多少？再背一笔分期，生活质量会怎样？答案不用猜，算给你看。

## Features

<table>
<tr>
<td width="50%">

### 睡后成本 Dashboard
实时展示你的生活燃烧率。按日/月/季/年灵活切换，饼图展示分类占比。

### 缴费日历
月历视图查看所有缴费计划。到期日标注金额，点击查看具体项目。

### 幸福感评分
0-100 分评分体系。分项健康度可视化，一眼看出哪个分类超标。

</td>
<td width="50%">

### 承担能力模拟
「如果我再买一个…」输入金额即时模拟对每日成本和幸福感评分的影响。

### 智能缴费追踪
到期自动推进，支持提前标记。左滑标记付款，简单直觉。

### 双周期账单
月租 4500 但按季付？分离心智周期和实际付款周期，自动换算。

</td>
</tr>
</table>

## Screenshots

<div align="center">
<img src="docs/screenshots/dashboard.jpg" width="250" />
&nbsp;&nbsp;
<img src="docs/screenshots/calendar.jpg" width="250" />
&nbsp;&nbsp;
<img src="docs/screenshots/happiness-research.jpg" width="250" />
</div>

## Category System

8 大类 **·** 26 子分类，覆盖日常固定支出：

> **居住** 房租 / 房贷 / 水电煤 / 物业费 / 停车费
>
> **交通** 车贷 / 车险 / 通勤月卡 / 加油
>
> **生活** 日常伙食 / 日用品
>
> **通信** 话费 / 宽带
>
> **数字订阅** 流媒体 / 生产力工具 / 云服务 / 游戏会员
>
> **医疗健康** 保险 / 健身 / 医疗体检
>
> **教育** 培训网课 / 书籍订阅
>
> **其他** 宠物 / 人情往来 / 其他

## Happiness Score

基于固定支出占税后收入的比例，0-100 分综合评分：

```
 95-100  优秀   ≤30%   😎  财务自由度高
 80-95   良好   ≤50%   😊  生活比较从容
 60-80   一般   ≤65%   😐  收支基本平衡
 35-60   偏紧   ≤80%   😰  有些紧张
  0-35   危险   >80%   😵  压力很大
```

分项对比各大类占收入比例与建议值，超标项高亮提醒。

## Tech Stack

| 层级 | 技术 |
|------|------|
| Framework | Flutter 3.41+ |
| Language | Dart 3.11+ |
| Architecture | Clean Architecture + MVVM |
| State | Provider |
| Storage | Hive (NoSQL) |
| Charts | fl_chart |

## Quick Start

```bash
git clone https://github.com/imK3/LifeCostTracker.git
cd LifeCostTracker/life_cost_tracker
flutter pub get
flutter run
```

> iOS 部署、环境配置等详见 [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)

## Project Structure

```
lib/
├── domain/          # 业务层：实体、仓库接口、用例
│   ├── entities/    # RecurringCost, InstallmentPlan, SleepCostSummary...
│   ├── repositories/
│   └── usecases/
├── data/            # 数据层：Hive 适配器和仓库实现
│   ├── adapters/
│   └── repositories/
└── presentation/    # 展示层：Views + ViewModels
    ├── viewmodels/
    └── views/       # Dashboard, Calendar, Simulator, Settings...
```

## Donate

一个人写代码有时候挺孤独的，如果这个小工具刚好帮到了你，那就太好了 🥹

请我喝杯咖啡？会让我开心一整天的那种 ☕✨

<div align="center">
<img src="docs/screenshots/eth_address.gif" width="200" />

`0x6dd5D3b87aAC6E0CB31F74248451D7536001f0c3`

<sub>ETH / ERC-20 · 不管多少都是心意 💛</sub>
</div>

## License

[MIT](LICENSE)

---

<div align="center">

*Built with Flutter & Hive*

*v2.0 · 2026-03-26*

</div>
