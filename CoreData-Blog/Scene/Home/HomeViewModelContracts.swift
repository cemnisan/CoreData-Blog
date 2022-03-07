//
//  HomeViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import CoreData

protocol HomeViewModelProtocol
{
    var delegate: HomeViewModelDelegate? { get set }
    func load()
    func selectAddButton()
}

protocol HomeViewModelDelegate: AnyObject
{
    func handleOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeViewModelRouter)
}

enum HomeViewModelRouter
{
    case add(AddArticleViewModelProtocol)
}

enum HomeViewModelOutput
{
    case loading(Bool)
    case showArticlesVia(NSFetchedResultsController<Article>)
    case showError(Error)
}
