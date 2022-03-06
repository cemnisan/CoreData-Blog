//
//  HomeViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import CoreData

protocol HomeViewModelProtocol
{
    var delegate: HomeViewModelDelegate? { get set }
    func fetchArticles()
}

protocol HomeViewModelDelegate: AnyObject
{
    func handleOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput
{
    case loading(Bool)
    case showArticle([Article])
}
