//
//  SearchService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import CoreData

final class SearchService
{
    var stack: CoreDataStack
    
    init(stack: CoreDataStack)
    {
        self.stack = stack
    }
}

extension SearchService: ISearchService
{
    func getArticles(with query: String,
                    completion: @escaping (Result<[Article]>) -> Void)
    {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        
        do {
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch let error {
            completion(.failure(error))
        }
    }
}
