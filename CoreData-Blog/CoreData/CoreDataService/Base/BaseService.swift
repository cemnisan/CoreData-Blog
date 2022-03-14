//
//  BaseService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import CoreData

class BaseService
{
    var stack: CoreDataStack
    var storedArticles: [Article]
    
    init(
        stack: CoreDataStack,
        storedArticles: [Article]
    ) {
        self.stack = stack
        self.storedArticles = storedArticles
    }
}

extension BaseService: IBaseService
{
    func removeOrAddFavorites(with id: UUID,
                              completion: @escaping (Result<Bool>) -> Void)
    {
        let idPredicate = NSPredicate(
            format: "%K = %@",
            (\Article.id)._kvcKeyPathString!,
            id as NSUUID)
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate  = idPredicate
        
        do {
            let foundArticle = try stack.managedContext.fetch(fetchRequest)
            foundArticle[0].isFavorite = !foundArticle[0].isFavorite
      
            stack.saveContext()
            
            foundArticle[0].isFavorite ? completion(.success(true)) : completion(.success(false))
        } catch {
            completion(.failure(error))
        }
    }
    
    func makePagination(currentArticlesCount: Int,
                        fetchRequest: NSFetchRequest<Article>,
                        completion: @escaping (Result<[Article]>) -> Void)
    {
        do {
            var fetchedArticles = try stack.managedContext.fetch(fetchRequest)
   
            if fetchedArticles.count != currentArticlesCount
            {
                for i in 0..<fetchedArticles.count
                {
                    storedArticles.append(fetchedArticles[i])
                }
                fetchedArticles = storedArticles
            } else {
                storedArticles = []
            }
            completion(.success(fetchedArticles))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeStoredArticles()
    {
        storedArticles.removeAll()
    }
}
