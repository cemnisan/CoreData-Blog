//
//  AddArticleContracts.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation

protocol AddArticleViewModelProtocol
{
    var delegate: AddArticleViewModelDelegate? { get set }
    func addArticle(with title: String, content: String)
}

protocol AddArticleViewModelDelegate: AnyObject {
    func handleOutput(_ output: AddArticleViewModelOutput)
}

enum AddArticleViewModelOutput
{
    case isAdded(Result<Bool>)
}
