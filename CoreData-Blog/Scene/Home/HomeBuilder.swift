//
//  HomeBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class HomeBuilder
{
    static func make() -> UINavigationController
    {
        let storyboard = UIStoryboard(name: K.Storyboard.home, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.home) as! HomeViewController
        
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        viewController.viewModel = HomeViewModel(service: CoreDataService(stack: app.stack))
        
        return UINavigationController(rootViewController: viewController)
    }
}
