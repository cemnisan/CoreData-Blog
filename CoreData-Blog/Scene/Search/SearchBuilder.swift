//
//  SearchBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

final class SearchBuilder
{
    static func make() -> SearchViewController
    {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        
        return viewController
    }
}
