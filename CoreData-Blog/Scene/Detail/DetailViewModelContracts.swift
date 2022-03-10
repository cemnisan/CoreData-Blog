//
//  DetailViewModelContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

protocol DetailViewModelProtocol
{
    var delegate: DetailViewModelDelegate? { get set }
    func addFavorites(with id: UUID)
}

protocol DetailViewModelDelegate: AnyObject
{
    func handleOutput(_ output: DetailViewModelOutput)
}

enum DetailViewModelOutput
{
    case isFavorited(Result<Bool>)
}
