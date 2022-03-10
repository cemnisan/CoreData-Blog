//
//  ISearchService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import Foundation

protocol ISearchService
{
    func getArticles(with query: String,
                     _ selectedCategory: String,
                     completion: @escaping (Result<[Article]>) -> Void)
    func getArticles(with category: String,
                     completion: @escaping (Result<[Article]>) -> Void)
    func addFavorites(with id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
}
