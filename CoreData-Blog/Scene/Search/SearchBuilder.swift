//
//  SearchBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

final class SearchBuilder
{
    static func make() -> UINavigationController
    {
        let storyboard = UIStoryboard(name: K.Storyboard.search, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.search) as! SearchViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        
        return UINavigationController(rootViewController: viewController)
    }
}
