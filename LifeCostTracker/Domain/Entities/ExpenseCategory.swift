//
//  ExpenseCategory.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

enum ExpenseCategory: String, CaseIterable, Codable {
    case food
    case transport
    case shopping
    case entertainment
    case utilities
    case other
    
    var displayName: String {
        switch self {
        case .food:
            return "餐饮"
        case .transport:
            return "交通"
        case .shopping:
            return "购物"
        case .entertainment:
            return "娱乐"
        case .utilities:
            return "生活缴费"
        case .other:
            return "其他"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transport:
            return "car"
        case .shopping:
            return "bag"
        case .entertainment:
            return "gamecontroller"
        case .utilities:
            return "house"
        case .other:
            return "ellipsis.circle"
        }
    }
}
