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
    func getFavoriteArticles(with category: String)
    {
        service.getFavoriteArticles(with: category) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.notify(.favoriteArticles(articles))
            case .failure(let error):
                self.notify(.error(error))
            }
        }
    }
    
    func addFavorites(with id: UUID)
    {
        service.addFavorites(with: id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let isFavorite):
                self.notify(.isFavorited(.success(isFavorite)))
            case .failure(let error):
                self.notify(.isFavorited(.failure(error)))
            }
        }
    }
    
    func selectedArticle(article: Article) {
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
