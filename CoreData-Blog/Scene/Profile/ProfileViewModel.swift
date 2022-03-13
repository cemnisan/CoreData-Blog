//
//  ProfileViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import Foundation

// MARK: - Initialize
final class ProfileViewModel
{
    weak var delegate: ProfileViewModelDelegate?
    private var service: IProfileService
    
    init(service: IProfileService)
    {
        self.service = service
    }
}

// MARK: - ViewModel Protocol
extension ProfileViewModel: ProfileViewModelProtocol
{
    func getFavoriteArticles(with category: String,
                             _ fetchOffset: Int)
    {
        service.getFavoriteArticles(with: category,
                                    fetchOffset) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success((let articles, let currentArticlesCount)):
                self.notify(.favoriteArticles(articles, currentArticlesCount))
            case .failure(let error):
                self.notify(.error(error))
            }
        }
    }
    
    func removeFavorites(with id: UUID,
                         on category: String)
    {
        service.removeOrAddFavorites(with: id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let isFavorite):
                self.notify(.isFavorited(.success(isFavorite)))
            case .failure(let error):
                self.notify(.isFavorited(.failure(error)))
            }
        }
    }
    
    func removeStoreArticles()
    {
        service.removeStoreArticles()
    }
    
    func selectedArticle(article: Article)
    {
        let viewModel = DetailViewModel(service: HomeService(stack: app.stack))
        delegate?.navigate(to: .detail(viewModel, article))
    }
}

// MARK: - Helpers
extension ProfileViewModel
{
    private func notify(_ output: ProfileViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}
