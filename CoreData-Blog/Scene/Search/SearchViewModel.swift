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
    func getArticles(with query: String,
                     _ category: String) {
        service.getArticles(with: query, category) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.notify(.foundArticles(articles))
            case .failure(let error):
                self.notify(.notFound(error))
            }
        }
    }
    
    func getArticles(with category: String) {
        service.getArticles(with: category) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.notify(.foundArticlesWithCategory(articles))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addFavorites(with id: UUID)
    {
        service.removeOrAddFavorites(with: id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let isFavorited):
                self.notify(.isFavorited(.success(isFavorited)))
            case .failure(let error):
                self.notify(.isFavorited(.failure(error)))
            }
        }
    }
    
    func selectedArticle(article: Article) {
        let viewModel = DetailViewModel(service: HomeService(stack: app.stack))
        delegate?.navigate(to: .detail(article, viewModel))
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
