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
    func getRecommendArticles(with category: String,
                     fetchOffset: Int,
                     completion: @escaping (Result<([Article], Int)>) -> Void)
    {        
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = categoryPredicate
        fetchRequest.fetchLimit = 6
        fetchRequest.fetchOffset = fetchOffset
        
        let currentArticlesCount = self.currentRecommendArticlesCount(category: categoryPredicate)

        self.makePagination(currentArticlesCount: currentArticlesCount,
                        fetchRequest: fetchRequest) { [weak self] (result) in
            guard let _ = self else { return }
            
            switch result {
            case .success(let articles):
                completion(.success((articles, currentArticlesCount)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getArticles(with query: String,
                     selectedCategory: String,
                     fetchOffset: Int,
                     completion: @escaping (Result<([Article], Int)>) -> Void)
    {
        let queryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        let categoryPredicate = NSPredicate(format: "category = %@", selectedCategory)
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [queryPredicate, categoryPredicate])
        fetchRequest.fetchLimit = 6
        fetchRequest.fetchOffset = fetchOffset
        
        let count = self.currentArticlesCountBySearch(query: queryPredicate,
                                                                     category: categoryPredicate)
        self.makePagination(currentArticlesCount: count,
                            fetchRequest: fetchRequest) { [weak self] (result) in
            guard let _ = self else { return }
            
            switch result {
            case .success(let articles):
                completion(.success((articles, count)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func currentRecommendArticlesCount(category: NSPredicate) -> Int
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
