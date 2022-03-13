//
//  SearchViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

protocol SearchViewModelProtocol
{
    var delegate: SearchViewModelDelegate? { get set }
    func getArticles(with query: String,
                     _ category: String,
                     fetchOffset: Int)
    func getArticles(with category: String,
                     fetchOffset: Int)
    func addFavorites(with id: UUID)
    func selectedArticle(article: Article)
    func removeStoredArticles()
}

protocol SearchViewModelDelegate: AnyObject
{
    func handleOutput(_ output: SearchViewModelOutput)
    func navigate(to router: SearchViewModelRouter)
}

enum SearchViewModelRouter
{
    case detail(Article, DetailViewModelProtocol)
}

enum SearchViewModelOutput
{
    case foundArticles(([Article], Int))
    case isFavorited(Bool)
    case foundArticlesWithCategory(([Article], Int))
    case showError(Error)
}
