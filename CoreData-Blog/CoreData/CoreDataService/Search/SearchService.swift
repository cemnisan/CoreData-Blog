//
//  SearchService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import CoreData

final class SearchService: BaseService { }

extension SearchService: ISearchService
{
    func getArticles(with query: String,
                     _ selectedCategory: String,
                     completion: @escaping (Result<[Article]>) -> Void)
    {
        let queryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        let categoryPredicate = NSPredicate(format: "category = %@", selectedCategory)
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                queryPredicate,
                categoryPredicate
            ]
        )
        
        do {
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getArticles(with category: String,
                     completion: @escaping (Result<[Article]>) -> Void)
    {
        let categoryPredicate = NSPredicate(format: "category = %@", category)
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = categoryPredicate
        
        do {
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch {
            completion(.failure(error))
        }
    }
}
