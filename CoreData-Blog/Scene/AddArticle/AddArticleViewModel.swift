//
//  AddArticleViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation

final class AddArticleViewModel
{
    let service: ICoreDataService
    weak var delegate: AddArticleViewModelDelegate?
    
    init(service: ICoreDataService) {
        self.service = service
    }
}

extension AddArticleViewModel: AddArticleViewModelProtocol
{
    func addArticle(with title: String, content: String)
    {
        do {
            try validateArticle(title: title, content: content)
            try service.addArticle(with: title, content)
            notify(.isAdded(.success(true)))
        } catch {
            notify(.isAdded(.failure(error)))
        }
    }
}

// MARK: - Handle Output Helper
extension AddArticleViewModel
{
    private func notify(_ output: AddArticleViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}

// MARK: - Validation
extension AddArticleViewModel
{
    private func validateArticle(title: String,
                                 content: String) throws
    {
        guard !title.isEmpty else { throw ValidateError.isTitleEmpty }
        guard title.count >= 3 else { throw ValidateError.titleTooShort }
        guard !content.isEmpty else { throw ValidateError.isContentEmpty }
        guard content.count >= 3 else { throw ValidateError.contentTooShort }
    }
}
