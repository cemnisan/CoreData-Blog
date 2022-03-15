//
//  SelectSegmentControl.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import Foundation

enum SelectCategory
{
    case swift
    case kotlin
    case go
    case javascript
}

extension SelectCategory: CaseIterable { }

extension SelectCategory: RawRepresentable
{
    typealias RawValue = String
    
    init?(rawValue: RawValue)
    {
        switch rawValue {
        case "Swift": self = .swift
        case "Kotlin": self = .kotlin
        case "Go": self = .go
        case "Javascript": self = .javascript
        default : return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .swift: return "Swift"
        case .kotlin: return "Kotlin"
        case .javascript: return "Javascript"
        case .go: return "Go"
        }
    }
}
