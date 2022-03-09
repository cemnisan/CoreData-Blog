//
//  BookMark.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

enum SelectBookMark
{
    case bookMark
    case bookMarkFill
    
    var selectedBookMark: String
    {
        switch self {
        case .bookMark:
            return "bookmark"
        case .bookMarkFill:
            return "bookmark.fill"
        }
    }
}
