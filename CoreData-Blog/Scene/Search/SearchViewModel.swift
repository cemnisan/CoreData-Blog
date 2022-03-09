//
//  SearchViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

// MARK: - Initialize
final class SearchViewModel
{
    weak var delegate: SearchViewModelDelegate?
    var service: ISearchService
    
    init(service: ISearchService)
    {
        self.service = service
    }
}

// MARK: - ViewModel Protocol
extension SearchViewModel: SearchViewModelProtocol
{
    func getArticles(with query: String)
    {
        service.getArticles(with: query) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.notify(.foundArticles(articles))
            case .failure(let error):
                self.notify(.notFound(error))
            }
        }
    }
}

// MARK: - Helpers
extension SearchViewModel
{
    private func notify(_ output: SearchViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}
