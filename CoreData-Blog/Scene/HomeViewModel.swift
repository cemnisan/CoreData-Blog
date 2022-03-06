//
//  HomeViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import CoreData

final class HomeViewModel: HomeViewModelProtocol
{
    weak var delegate: HomeViewModelDelegate?
    var coreDataStack: CoreDataStack?
    
    private var articles: [Article] = []
    private var asyncFetch: NSAsynchronousFetchRequest<Article>?
    
    init(coreDataStack: CoreDataStack)
    {
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Delegate
extension HomeViewModel
{
    func fetchArticles()
    {
        notify(.loading(true))
        let articleFetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let asyncFetch = NSAsynchronousFetchRequest<Article>(fetchRequest: articleFetchRequest,
                                                         completionBlock: { [unowned self] (result: NSAsynchronousFetchResult) in
            guard let articles = result.finalResult else { return }
                                                            
            self.articles = articles
            self.notify(.showArticle(articles))
        })
        
        do {
            try coreDataStack!.managedContext.execute(asyncFetch)
            notify(.loading(false))
        } catch let error as NSError {
            print("Fetched error: \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Helpers
extension HomeViewModel
{
    func importJSONSeedDataIfNeeded()
    {
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        
        do {
            let articleCount = try coreDataStack!.managedContext.count(for: fetchRequest)

            guard articleCount == 0 else { return }
            try importJSONSeedData()
        } catch let error as NSError {
            print("Error Fetching: \(error), \(error.userInfo)")
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
            
            let author = Author(context: coreDataStack!.managedContext)
            author.userName = authorDict["userName"]
        
            let articleTitle = jsonDictionary["title"] as? String
            let articleContent = jsonDictionary["content"] as? String
            
            let article = Article(context: coreDataStack!.managedContext)
            article.title = articleTitle
            article.content = articleContent
            article.author = author
         }
        coreDataStack!.saveContext()
    }
    
    private func notify(_ output: HomeViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}
