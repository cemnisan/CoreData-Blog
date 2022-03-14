//
//  ProfileViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import CoreData

protocol ProfileViewModelProtocol
{
    var delegate: ProfileViewModelDelegate? { get set }
    
    func loadFavoriteArticles(with category: String, _ fetchOffset: Int)
    func removeFavorites(with id: UUID, on category: String)
    func removeStoredArticles()
    func selectedArticle(article: Article)
}

protocol ProfileViewModelDelegate: AnyObject
{
    func handleOutput(_ output: ProfileViewModelOutput)
    func navigate(to router: ProfileViewModelRouter)
}

enum ProfileViewModelRouter
{
    case detail(DetailViewModelProtocol, Article)
}

enum ProfileViewModelOutput
{
    case favoriteArticles([Article], Int)
    case removeFavorite(Bool)
    case showError(Error)
}
