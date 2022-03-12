//
//  ProfileService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import CoreData

final class ProfileService: BaseService
{
    override init(stack: CoreDataStack)
    {
        super.init(stack: stack)
    }
}

extension ProfileService: IProfileService
{
//    func getFavoriteArticles(with category: String,
//                             _ fetchOffset: Int,
//                             completion: @escaping (Result<([Article], Int)>) -> Void)
//    {
//        var fetchedArticle = [Article]()
//        
//        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
//        let categoryPredicate = NSPredicate(format: "category = %@", category)
//        
//        let dateSort = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
//        let reversedSort = dateSort.reversedSortDescriptor as! NSSortDescriptor
//        
//        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
//        let baseRequest: NSFetchRequest<Article> = Article.fetchRequest()
//        baseRequest.fetchLimit = fetchOffset
//        baseRequest.sortDescriptors = [reversedSort]
//        
//        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
//        fetchRequest.sortDescriptors = [reversedSort]
//        fetchRequest.fetchLimit  = 5
//        fetchRequest.fetchOffset = fetchOffset
//
//        do {
//            let currentArticlesCount = try stack.managedContext.count(for: NSFetchRequest(entityName: "Article"))
//            let articles = try stack.managedContext.fetch(fetchRequest)
//            let newArticles = try stack.managedContext.fetch(baseRequest)
//            fetchedArticle = articles
//            
//            if fetchOffset > 0 {
//                for i in 0..<newArticles.count {
//                    if newArticles[i].id != fetchedArticle[i].id {
//                        fetchedArticle.append(newArticles[i])
//                        print(fetchedArticle.count)
//                    }
//                }
//            }
//            
//            completion(.success((fetchedArticle, currentArticlesCount)))
//        } catch {
//            completion(.failure(error))
//        }
//    }
    
    func getFavoriteArticles(with category: String,
                      _ fetchOffset: Int,
                      completion: @escaping (Result<([Article], Int)>) -> Void)
    {
        var subArticles: [Article] = []
        
        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        
        let dateSort = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedSort = dateSort.reversedSortDescriptor as! NSSortDescriptor
        
        let baseRequest: NSFetchRequest<Article> = Article.fetchRequest()
        baseRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
        baseRequest.sortDescriptors = [reversedSort]
        baseRequest.fetchLimit = 5
        baseRequest.fetchOffset = fetchOffset
        
        let subRequest: NSFetchRequest<Article> = Article.fetchRequest()
        subRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
        subRequest.sortDescriptors = [reversedSort]
        subRequest.fetchLimit = 5
        
        do {
            let currentArticles = try stack.managedContext.count(for: NSFetchRequest(entityName: "Article"))
            var baseArticles = try stack.managedContext.fetch(baseRequest)
            
            if fetchOffset > 0 {
                subArticles = try stack.managedContext.fetch(subRequest)
                for i in 0..<baseArticles.count {
                    subArticles.append(baseArticles[i])
                }
                baseArticles = subArticles
            }
            
            completion(.success((baseArticles, currentArticles)))
        } catch {
            completion(.failure(error))
        }
    }
}
