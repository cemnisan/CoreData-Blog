//
//  SelectSegmentControl.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import Foundation

enum SelectCategory
{
    case software
    case hardware
    case swift
    case kotlin
    
    var category: String {
        switch self {
        case .software:
            return "Software"
        case .hardware:
            return "Hardware"
        case .swift:
            return "Swift"
        case .kotlin:
            return "Kotlin"
        }
    }
    
    static func selectSegmentControl(with category: String) -> SelectCategory
    {
        switch category {
        case "Software":
            return .software
        case "Hardware":
            return .hardware
        case "Swift":
            return .swift
        case "Kotlin":
            return .kotlin
        default:
            return .software
        }
    }
}
