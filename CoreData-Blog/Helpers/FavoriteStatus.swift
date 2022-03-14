//
//  FavoriteStatus.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 15.03.2022.
//

import Foundation

enum FavoriteStatus
{
    case success
    case info
    
    static func selectStatus(with isFavorite: Bool) -> FavoriteStatus
    {
        switch isFavorite {
        case true: return .success
        case false: return .info
        }
    }
}
