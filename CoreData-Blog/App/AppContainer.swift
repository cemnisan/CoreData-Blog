//
//  AppContainer.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation

let app = AppContainer()

final class AppContainer
{    
    let router  = AppRouter()
    let service = CoreDataService(coreDataStack: CoreDataStack(modelName: K.Model.modelName))
} 

