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
        
        let nameSort = NSSortDescriptor(key: #keyPath(Article.title),
                                        ascending: true)
        fetchedRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "Articles")
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
}

// MARK: - Import Seed Data
extension CoreDataService
{
    func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest<Article>(entityName: K.Entity.article)
        
        do {
            let articleCount = try coreDataStack.managedContext.count(for: fetchRequest)
            
            guard articleCount == 0 else { return }
            try importJSONSeedData()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func importJSONSeedData() throws
    {
        let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
        let jsonData = try Data(contentsOf: jsonURL)
        
        guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [String: Any],
              let responseDict = jsonDict["response"] as? [String: Any],
              let jsonArray = responseDict["articles"] as? [[String: Any]] else { return }
        
        for jsonDictionary in jsonArray
        {
            guard let authorDict = jsonDictionary["author"] as? [String: String] else { return }
            
            let author = Author(context: coreDataStack.managedContext)
            author.userName = authorDict["userName"]
            
            let articleTitle = jsonDictionary["title"] as? String
            let articleContent = jsonDictionary["content"] as? String
            
            let article = Article(context: coreDataStack.managedContext)
            article.title = articleTitle
            article.content = articleContent
            article.author = author
        }
        coreDataStack.saveContext()
    }
}
