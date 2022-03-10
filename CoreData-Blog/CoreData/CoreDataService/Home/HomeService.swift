//
//  CoreDataService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation
import CoreData

final class HomeService: BaseService
{
    override init(stack: CoreDataStack) {
        super.init(stack: stack)
    }
}

extension HomeService: IHomeService
{
    func fetchArticles(completion: @escaping (Result<[Article]>) -> Void)
    {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let dateSort: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedDate = dateSort.reversedSortDescriptor as! NSSortDescriptor
        
        fetchRequest.sortDescriptors = [reversedDate]
        
        do {
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func addArticle(with title: String,
                    _ content:  String,
                    _ category: String) throws
    {
        let article = Article(context: stack.managedContext)
        let author  = Author(context: stack.managedContext)
        
        author.userName     = "cemnisan" // todo.
        
        article.title       = title
        article.content     = content
        article.category    = category
        article.isFavorite  = false
        article.id          = UUID()
        article.createdDate = Date()
        article.author      = author
        
        stack.saveContext()
    }
}
