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
        let storyboard = UIStoryboard(name: K.Storyboard.home,
                                      bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.home) as! HomeViewController
        navigationController.viewModel = HomeViewModel(coreDataService: app.service)
        
        return navigationController
    }
}
