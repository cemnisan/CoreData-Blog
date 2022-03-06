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
        let storyboard = UIStoryboard(name: K.Storyboard.homeStoryboard,
                                      bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.homeStoryboard) as! HomeViewController
        navigationController.viewModel = HomeViewModel(coreDataService: AppContainer.shared.coreDataService)
        
        return navigationController
    }
}
