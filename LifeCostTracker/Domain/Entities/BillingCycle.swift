//
//  BillingCycle.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

enum BillingCycle: String, CaseIterable, Codable {
    case weekly
    case monthly
    case yearly
    
    var displayName: String {
        switch self {
        case .weekly:
            return "每周"
        case .monthly:
            return "每月"
        case .yearly:
            return "每年"
        }
    }
    
    var daysInCycle: Int {
        switch self {
        case .weekly:
            return 7
        case .monthly:
            return 30
        case .yearly:
            return 365
        }
    }
}
