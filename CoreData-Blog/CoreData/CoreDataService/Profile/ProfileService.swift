//
//  ProfileService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import CoreData

final class ProfileService: BaseService
{
    private var storedArticles: [Article]
    
    init(stack: CoreDataStack,
         storedArticles: [Article] = []
    ) {
        self.storedArticles = storedArticles
        super.init(stack: stack)
    }
}

extension ProfileService: IProfileService
{
    func getFavoriteArticles(with category: String,
                             _ fetchOffset: Int,
                             completion: @escaping (Result<([Article], Int)>) -> Void)
    {
        let articlesCount = self.currentFavoriteArticlesCount(category: category)
        
        let categoryPredicate: NSPredicate = NSPredicate(format: "category = %@", category)
        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
        
        let dateSort = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedSort = dateSort.reversedSortDescriptor as! NSSortDescriptor
        
        let baseRequest: NSFetchRequest<Article> = Article.fetchRequest()
        baseRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
        baseRequest.sortDescriptors = [reversedSort]
        baseRequest.fetchLimit = 5
        baseRequest.fetchOffset = fetchOffset
        
        do {
            var baseArticles = try stack.managedContext.fetch(baseRequest)
            
            if baseArticles.count > 0 &&
               baseArticles.count != articlesCount
            {
                for i in 0..<baseArticles.count {
                    storedArticles.append(baseArticles[i])
                }
                
                baseArticles = storedArticles
            } else {
                storedArticles = []
            }
            
            completion(.success((baseArticles, articlesCount)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeStoreArticles()
    {
        storedArticles.removeAll()
    }
    
    private func currentFavoriteArticlesCount(category: String) -> Int
    {
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
        
        let articlesCount: NSFetchRequest<Article> = Article.fetchRequest()
        articlesCount.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,
                                                                                      favoritePredicate])
        let count = try! stack.managedContext.count(for: articlesCount)
        return count
    }
}
