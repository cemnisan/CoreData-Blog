//
//  SearchService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import CoreData

final class SearchService: BaseService
{
    override init(
        stack: CoreDataStack,
        storedArticles: [Article] = []
    ) {
        super.init(stack: stack, storedArticles: storedArticles)
    }
}

extension SearchService: ISearchService
{
    func getArticles(with category: String,
                     fetchOffset: Int,
                     completion: @escaping (Result<([Article], Int)>) -> Void)
    {        
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = categoryPredicate
        fetchRequest.fetchLimit = 6
        fetchRequest.fetchOffset = fetchOffset
        
        let currentArticlesCount = self.currentArticlesCountByCategory(category: categoryPredicate)
        print("category: \(category)")
        print("currentArticlesCountByCategory: \(currentArticlesCount)")
        self.pagination(currentArticlesCount: currentArticlesCount,
                        fetchRequest: fetchRequest) { [weak self] (result) in
            guard let _ = self else { return }
            
            switch result {
            case .success(let articles):
                print("getArticlesWithCategory", articles.count)
                completion(.success((articles, currentArticlesCount)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getArticles(with query: String,
                     _ selectedCategory: String,
                     fetchOffset: Int,
                     completion: @escaping (Result<([Article], Int)>) -> Void)
    {
        let queryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        let categoryPredicate = NSPredicate(format: "category = %@", selectedCategory)
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [queryPredicate, categoryPredicate])
        fetchRequest.fetchLimit = 6
        fetchRequest.fetchOffset = fetchOffset
        
        let currentArticlesCount = self.currentArticlesCountBySearch(query: queryPredicate,
                                                                    category: categoryPredicate)
        print("currentArticlesCountByQuery: \(currentArticlesCount)")
        self.pagination(currentArticlesCount: currentArticlesCount,
                        fetchRequest: fetchRequest) { [weak self] (result) in
            guard let _ = self else { return }
            
            switch result {
            case .success(let articles):
                print("getArticlesWithQuery", articles.count)
                completion(.success((articles,
                                     currentArticlesCount)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func currentArticlesCountByCategory(category: NSPredicate) -> Int
    {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = category
        
        let count = try! stack.managedContext.count(for: fetchRequest)
        
        return count
    }
    
    private func currentArticlesCountBySearch(query: NSPredicate,
                                              category: NSPredicate) -> Int
    {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [query,
                                                                                     category])
        let count = try! stack.managedContext.count(for: fetchRequest)
        
        return count
    }
}
