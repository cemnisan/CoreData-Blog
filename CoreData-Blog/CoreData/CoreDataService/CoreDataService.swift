//
//  CoreDataService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation
import CoreData

final class CoreDataService
{
    private let coreDataStack: CoreDataStack
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        
        let fetchedRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: #keyPath(Article.createdDate), ascending: true)
        let reversedDate = dateSort.reversedSortDescriptor as! NSSortDescriptor
        
        fetchedRequest.sortDescriptors = [reversedDate]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "Articles"
        )
        return fetchedResultsController
    }()
    
    init(coreDataStack: CoreDataStack)
    {
        self.coreDataStack = coreDataStack
    }
}

extension CoreDataService: ICoreDataService
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
        let article = Article(context: coreDataStack.managedContext)
        let author  = Author(context: coreDataStack.managedContext)
        author.userName = "cemnisan" // todo.
        
        article.title = title
        article.content = content
        article.createdDate = Date()
        article.author = author
        
        coreDataStack.saveContext()
    }
}
