//
//  AppRouter.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import UIKit

final class AppRouter
{
    var window: UIWindow
    
    init(){
        window = UIWindow(frame: UIScreen.main.bounds)
    }
}

extension AppRouter
{
    func start(with windowScene: UIWindowScene)
    {
        let viewController = HomeBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
