//
//  WishlistItem.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

struct WishlistItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String?
    let targetDate: Date?
    let totalCost: Decimal
    let estimatedUsageDays: Int? // For daily cost calculation
    let priority: Priority
    let photoURL: URL?
    let linkURL: URL?
    let isOwned: Bool
    let actualUsageDays: Int? // Only for owned items
    
    var dailyCost: Decimal? {
        // If owned and we have actual usage days, calculate based on that
        if isOwned, let actualDays = actualUsageDays, actualDays > 0 {
            return totalCost / Decimal(actualDays)
        }
        
        // If target date is set, calculate daily savings needed
        if let target = targetDate, target > Date() {
            let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 1
            return totalCost / Decimal(max(days, 1))
        }
        
        // Otherwise, calculate daily ownership cost based on estimated usage
        if let usageDays = estimatedUsageDays, usageDays > 0 {
            return totalCost / Decimal(usageDays)
        }
        
        return nil
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        targetDate: Date? = nil,
        totalCost: Decimal,
        estimatedUsageDays: Int? = nil,
        priority: Priority = .medium,
        photoURL: URL? = nil,
        linkURL: URL? = nil,
        isOwned: Bool = false,
        actualUsageDays: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.targetDate = targetDate
        self.totalCost = totalCost
        self.estimatedUsageDays = estimatedUsageDays
        self.priority = priority
        self.photoURL = photoURL
        self.linkURL = linkURL
        self.isOwned = isOwned
        self.actualUsageDays = actualUsageDays
    }
}
