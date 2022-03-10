//
//  ProfileViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

protocol ProfileViewModelProtocol
{
    var delegate: ProfileViewModelDelegate? { get set }
    func getFavoriteArticles(with category: String)
    func addFavorites(with id: UUID)
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
    case isFavorited(Result<Bool>)
    case favoriteArticles([Article])
    case error(Error)
}
