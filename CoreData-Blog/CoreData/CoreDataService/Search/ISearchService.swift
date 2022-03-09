//
//  ISearchService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import Foundation

protocol ISearchService
{
    func getArticles(with query: String, completion: @escaping (Result<[Article]>) -> Void)
}
