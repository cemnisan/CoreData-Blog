//
//  CoreDataService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation
import CoreData

final class HomeService
{
    private let stack: CoreDataStack

    init(stack: CoreDataStack)
    {
        self.stack = stack
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
    
    func addFavorites(with isFavorite: Bool,
                      _ id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
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
            foundArticle[0].isFavorite = isFavorite
      
            stack.saveContext()
            
            foundArticle[0].isFavorite ? completion(.success(true)) : completion(.success(false))
        } catch {
            completion(.failure(error))
        }
    }
}
