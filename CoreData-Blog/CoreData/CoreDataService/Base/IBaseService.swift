//
//  IBaseService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import CoreData

protocol IBaseService
{
    func removeStoredArticles()
    func removeOrAddFavorites(with id: UUID,
                      completion: @escaping (Result<(Article, Bool)>) -> Void)
    func makePagination(currentArticlesCount: Int,
                    fetchRequest: NSFetchRequest<Article>,
                    completion: @escaping (Result<[Article]>) -> Void)
}
