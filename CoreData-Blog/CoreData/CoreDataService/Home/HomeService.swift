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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        
        let fetchedRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedDate = dateSort.reversedSortDescriptor as! NSSortDescriptor
        
        fetchedRequest.sortDescriptors = [reversedDate]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: stack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "Articles"
        )
        return fetchedResultsController
    }()
    
    init(stack: CoreDataStack)
    {
        self.stack = stack
    }
}

extension HomeService: IHomeService
{
    func fetchArticles(completion: @escaping (Result<NSFetchedResultsController<Article>>) -> Void) {
        do {
            try fetchedResultsController.performFetch()
            completion(.success(fetchedResultsController))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func addArticle(with title: String, _ content: String) throws
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
    
    func addFavorites(with isFavorite: Bool, _ article: Article) throws
    {
        let articleIndexPath    = fetchedResultsController.indexPath(forObject: article)
        let foundArticle        = fetchedResultsController.object(at: articleIndexPath!)
        foundArticle.isFavorite = isFavorite
        
        stack.saveContext()
    }
}
