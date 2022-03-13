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
    let stack = CoreDataStack(modelName: K.Model.modelName)
} 
