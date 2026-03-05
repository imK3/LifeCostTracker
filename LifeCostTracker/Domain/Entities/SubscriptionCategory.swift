//
//  SubscriptionCategory.swift
//  LifeCostTracker
//
//  Created by LifeCostTracker Team
//

import Foundation

enum SubscriptionCategory: String, CaseIterable, Codable {
    case streaming
    case productivity
    case foodDelivery
    case fitness
    case news
    case cloudServices
    case digitalPeripherals
    case gaming
    case musicStreaming
    case other
    
    var displayName: String {
        switch self {
        case .streaming:
            return "流媒体"
        case .productivity:
            return "生产力"
        case .foodDelivery:
            return "外卖"
        case .fitness:
            return "健身"
        case .news:
            return "新闻"
        case .cloudServices:
            return "云服务/工具"
        case .digitalPeripherals:
            return "数码外设"
        case .gaming:
            return "游戏娱乐"
        case .musicStreaming:
            return "音乐串流"
        case .other:
            return "其他"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .streaming:
            return "tv"
        case .productivity:
            return "doc.text"
        case .foodDelivery:
            return "takeoutbag.and.cup.and.straw"
        case .fitness:
            return "figure.run"
        case .news:
            return "newspaper"
        case .cloudServices:
            return "cloud"
        case .digitalPeripherals:
            return "keyboard"
        case .gaming:
            return "gamecontroller"
        case .musicStreaming:
            return "music.note"
        case .other:
            return "ellipsis.circle"
        }
    }
}
