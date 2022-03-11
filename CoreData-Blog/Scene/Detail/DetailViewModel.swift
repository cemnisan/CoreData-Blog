//
//  DetailViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

// MARK: - Initialize
final class DetailViewModel
{
    weak var delegate: DetailViewModelDelegate?
    private var service: IHomeService
    
    init(service: IHomeService)
    {
        self.service = service
    }
}

// MARK: - View Model Protocol
extension DetailViewModel: DetailViewModelProtocol
{
    func addFavorites(with id: UUID) {
        service.removeOrAddFavorites(with: id) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let isFavorited):
                self.notify(with: .isFavorited(.success(isFavorited)))
            case .failure(let error):
                self.notify(with: .isFavorited(.failure(error)))
            }
        }
    }
}

// MARK: - Helpers
extension DetailViewModel
{
    private func notify(with output: DetailViewModelOutput)
    {
        delegate?.handleOutput(output)
    }
}
