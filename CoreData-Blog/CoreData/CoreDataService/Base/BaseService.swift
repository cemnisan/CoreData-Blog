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
    
    init(stack: CoreDataStack)
    {
        self.stack = stack
    }
}

extension BaseService: IBaseService
{
    func addFavorites(with id: UUID, completion: @escaping (Result<Bool>) -> Void)
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
}
