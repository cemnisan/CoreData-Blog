//
//  HomeBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class HomeBuilder
{
    static func make() -> HomeViewController
    {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        navigationController.viewModel = HomeViewModel(coreDataStack: AppContainer.shared.coreDataStack)
        
        return navigationController
    }
}
