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
    
    func loadPaginatedArticles(with fetchOffset: Int)
    func selectedArticle(article: Article)
    func addFavorites(with id: UUID)
    func removeStoredArticles()
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
    case detail(Article, DetailViewModelProtocol)
}

enum HomeViewModelOutput
{
    case paginatedArticles(([Article], Int))
    case showError(Error)
    case isFavorited(Bool)
}
