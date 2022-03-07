//
//  AddArticleBuilder.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import UIKit

final class AddArticleBuilder
{
    static func make(viewModel: AddArticleViewModelProtocol) -> AddArticleViewController
    {
        let storyboard = UIStoryboard(name: K.Storyboard.add, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: K.Storyboard.add) as! AddArticleViewController
        viewController.viewModel = viewModel
        
        return viewController
    }
}
