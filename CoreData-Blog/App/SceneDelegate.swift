//
//  SceneDelegate.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        AppContainer.shared.appRouter.start(with: windowScene)
    }
}

