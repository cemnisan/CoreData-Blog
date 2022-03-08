//
//  ProfileBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

final class ProfileBuilder
{
    static func make() -> UINavigationController
    {
        let storyboard     = UIStoryboard(name: K.Storyboard.profile, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.profile) as! ProfileViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
        
        return UINavigationController(rootViewController: viewController)
    }
}
