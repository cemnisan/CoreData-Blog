//
//  IProfileService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import CoreData


protocol IProfileService
{
    func getFavoriteArticles(with category: String,
                             _ fetchOffset: Int,
                             completion: @escaping (Result<([Article], Int)>) -> Void)
    func removeOrAddFavorites(with id: UUID,
                              completion: @escaping (Result<Bool>) -> Void)
}
