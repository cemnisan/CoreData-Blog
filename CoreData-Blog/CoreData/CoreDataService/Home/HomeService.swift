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
    
    private lazy var dateSort: NSSortDescriptor = {
        return NSSortDescriptor(
            key: #keyPath(Article.createdDate),
            ascending: true)
    }()

    init(stack: CoreDataStack)
    {
        self.stack = stack
    }
}

extension HomeService: IHomeService
{
    func fetchArticles(completion: @escaping (Result<[Article]>) -> Void)
    {
        do {
            let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
            let reversedDate = dateSort.reversedSortDescriptor as! NSSortDescriptor
            
            fetchRequest.sortDescriptors = [reversedDate]
            
            let articles = try stack.managedContext.fetch(fetchRequest)
            completion(.success(articles))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func addArticle(with title: String,
                    _ content: String) throws
    {
        let article = Article(context: stack.managedContext)
        let author  = Author(context: stack.managedContext)
        
        author.userName     = "cemnisan" // todo.
        
        article.title       = title
        article.content     = content
        article.createdDate = Date()
        article.author      = author
        article.isFavorite  = false
        
        stack.saveContext()
    }
    
    // Todo: use article.id instead of article.title
    func addFavorites(with isFavorite: Bool,
                      _ article: Article) throws
    {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let namePredicate: NSPredicate = NSPredicate(format: "%K = %@", #keyPath(Article.title), article.title!)
        fetchRequest.predicate = namePredicate
        
        do {
            let foundArticle = try stack.managedContext.fetch(fetchRequest)

            foundArticle[0].isFavorite = !foundArticle[0].isFavorite
            stack.saveContext()
        } catch {
            print(error)
        }
    }
}
