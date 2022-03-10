//
//  HomeViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation

protocol HomeViewModelProtocol
{
    var delegate: HomeViewModelDelegate? { get set }
    func load()
    func selectAddButton()
    func addFavorites(with id: UUID)
    func selectedArticle(article: Article)
}

protocol HomeViewModelDelegate: AnyObject
{
    func handleOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeViewModelRouter)
}

enum HomeViewModelRouter
{
    case add(AddArticleViewModelProtocol)
    case detail(Article, DetailViewModelProtocol)
}

enum HomeViewModelOutput
{
    case loading(Bool)
    case showArticlesVia([Article])
    case showError(Error)
    case isFavorited(Result<Bool>)
}
