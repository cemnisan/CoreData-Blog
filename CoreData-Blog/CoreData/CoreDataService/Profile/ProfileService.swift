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
    func getFavoriteArticles(with category: String, completion: @escaping (Result<[Article]>) -> Void)
    {
        let favoritePredicate = NSPredicate(format: "isFavorite == YES")
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedSort = sortDescriptor.reversedSortDescriptor as! NSSortDescriptor
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favoritePredicate, categoryPredicate])
        fetchRequest.sortDescriptors = [reversedSort]
        
        do {
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch {
            completion(.failure(error))
        }
    }
}

