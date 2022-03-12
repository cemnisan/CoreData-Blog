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
    func getFavoriteArticles(with category: String,
                             _ fetchOffset: Int,
                             completion: @escaping (Result<([Article], Int)>) -> Void)
    {
        var fetchedArticle = [Article]()
        
        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
        fetchRequest.fetchLimit = 5
        fetchRequest.fetchOffset = fetchOffset

        do {
            let currentArticlesCount = try stack.managedContext.count(for: NSFetchRequest(entityName: "Article"))
            let articles = try stack.managedContext.fetch(fetchRequest)
            for i in 0..<articles.count {
                let article: Article = articles[i]
                fetchedArticle.append(article)
            }
            completion(.success((articles, currentArticlesCount)))
        } catch {
            completion(.failure(error))
        }
    }
}

