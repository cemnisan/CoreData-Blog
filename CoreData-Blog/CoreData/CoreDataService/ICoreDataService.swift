//
//  ICoreDataService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation
import CoreData

protocol ICoreDataService
{
    func fetchArticles(completion: @escaping (Result<NSFetchedResultsController<Article>>) -> Void)
    func addArticle(with title: String, _ content: String) throws
    func importJSONSeedDataIfNeeded()
}
