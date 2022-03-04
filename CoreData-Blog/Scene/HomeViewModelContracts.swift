//
//  HomeViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation

protocol HomeViewModelProtocol
{
    var delegate: HomeViewModelDelegate? { get set }
    func load()
}

protocol HomeViewModelDelegate: AnyObject
{
    func handleOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput
{
    case showArticle
}
