//
//  AppContainer.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation

final class AppContainer
{
    static let shared = AppContainer()
    
    let appRouter     = AppRouter()
    let coreDataStack = CoreDataStack(modelName: K.Entity.article)
}
