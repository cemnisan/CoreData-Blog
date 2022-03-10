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
}

extension SelectCategory: CaseIterable { }

extension SelectCategory: RawRepresentable
{
    typealias RawValue = String
    
    init?(rawValue: RawValue)
    {
        switch rawValue {
        case "Software": self = .software
        case "Hardware": self = .hardware
        case "Swift": self = .swift
        case "Kotlin": self = .kotlin
        default : return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .hardware: return "Hardware"
        case .software: return "Software"
        case .swift: return "Swift"
        case .kotlin: return "Kotlin"
        }
    }
}
