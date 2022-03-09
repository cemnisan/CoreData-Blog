//
//  SearchViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

protocol SearchViewModelProtocol
{
    var delegate: SearchViewModelDelegate? { get set }
    func getArticles(with query: String)
}

protocol SearchViewModelDelegate: AnyObject
{
    func handleOutput(_ output: SearchViewModelOutput)
}

enum SearchViewModelOutput
{
    case foundArticles([Article])
    case notFound(Error)
}
