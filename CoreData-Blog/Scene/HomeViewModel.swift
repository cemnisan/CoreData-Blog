//
//  HomeViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol
{
    weak var delegate: HomeViewModelDelegate?
    var coreDataStack: CoreDataStack?
    
    init(coreDataStack: CoreDataStack)
    {
        self.coreDataStack = coreDataStack
    }
}

extension HomeViewModel
{
    func load()
    {
        print("Hello, world!")
    }
}
