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
    func getArticles(with query: String, _ category: String)
    func getArticles(category: String)
    func addFavorites(with id: UUID)
    func selectedArticle(article: Article)
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
    case foundArticles([Article])
    case isFavorited(Result<Bool>)
    case foundArticlesWithCategory([Article])
    case notFound(Error)
}
