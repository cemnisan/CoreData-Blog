//
//  ProfileBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

final class ProfileBuilder
{
    static func make() -> ProfileViewController
    {
        let storyboard     = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 3)
        
        return viewController
    }
}
