//
//  Priority.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

enum Priority: Int, CaseIterable, Codable, Comparable {
    case low = 1
    case medium = 2
    case high = 3
    
    var displayName: String {
        switch self {
        case .low:
            return "低"
        case .medium:
            return "中"
        case .high:
            return "高"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .low:
            return "flag"
        case .medium:
            return "flag.fill"
        case .high:
            return "exclamationmark.triangle.fill"
        }
    }
    
    var colorName: String {
        switch self {
        case .low:
            return "SecondaryLabel"
        case .medium:
            return "SystemOrange"
        case .high:
            return "SystemRed"
        }
    }
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
