//
//  ICoreDataService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation
import CoreData

protocol IHomeService
{
    func fetchArticles(completion: @escaping (Result<[Article]>) -> Void)
    func addArticle(with title: String,
                    _ content: String,
                    _ category: String) throws
    func addFavorites(with isFavorite: Bool,
                      _ id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
}
