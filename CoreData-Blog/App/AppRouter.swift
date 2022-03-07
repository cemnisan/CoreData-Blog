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
    // If the system version of device is greater than 13.0*
    // this func execute on sceneDelegate
    @available(iOS 13.0, *)
    func start(with windowScene: UIWindowScene)
    {
        let viewController = HomeBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
       
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // If the system version of device is lower than 13.0
    // this func execute on appDelegate.
    func start()
    {
        let viewController = HomeBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
       
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
