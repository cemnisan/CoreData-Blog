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
    
    func loadFoundArticles(with query: String,
                           category: String,
                           fetchOffset: Int)
    func loadRecommendArticles(with category: String, fetchOffset: Int)
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
    case isFavorited((Article, Bool))
    case recommendArtciles(([Article], Int))
    case showError(Error)
}
