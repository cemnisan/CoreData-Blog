//
//  IProfileService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import Foundation

protocol IProfileService
{
    func getFavoriteArticles(with category: String, completion: @escaping (Result<[Article]>) -> Void)
    func addFavorites(with id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
}
