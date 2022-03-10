//
//  IBaseService.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import Foundation

protocol IBaseService
{
    func addFavorites(with id: UUID,
                      completion: @escaping (Result<Bool>) -> Void)
}
