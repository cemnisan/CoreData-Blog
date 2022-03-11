//
//  HomeViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import CoreData

// MARK: - Initialize
final class HomeViewModel: HomeViewModelProtocol
{
    weak var delegate: HomeViewModelDelegate?
    private let service: IHomeService
    
    init(service: IHomeService)
    {
        self.service = service
    }
}

// MARK: - ViewModel's Protocol
extension HomeViewModel
{
    func load()
    {
        notify(.loading(true))
        
        service.fetchArticles { [weak self] result in
            guard let self = self else { return }
            self.notify(.loading(false))
           
            switch result {
            case .success(let articles):
                self.notify(.showArticlesVia(articles))
            case .failure(let error):
                self.notify(.showError(error))
            }
        }
    }
    
    func addFavorites(with id: UUID) {
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
    
    func selectAddButton() {
        let addViewModel = AddArticleViewModel(service: service)
        delegate?.navigate(to: .add(addViewModel))
    }
    
    func selectedArticle(article: Article)
    {
        let detailViewModel = DetailViewModel(service: service)
        delegate?.navigate(to: .detail(article, detailViewModel))
    }
}

// MARK: - Helpers
extension HomeViewModel
{
    private func notify(_ output: HomeViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}
