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
    func fetchArticles(fetchOffet: Int,
                       completion: @escaping (Result<([Article], Int)>) -> Void)
    func removeOrAddFavorites(with id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
    func addArticle(with title: String,
                    _ content: String,
                    _ category: String) throws
    func removeStoredArticles()
}
