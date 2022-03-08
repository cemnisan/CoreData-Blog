//
//  DetailViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

final class DetailViewModel: DetailViewModelProtocol
{
    weak var delegate: DetailViewModelDelegate?
    private var service: ICoreDataService
    
    init(service: ICoreDataService)
    {
        self.service = service
    }
}

extension DetailViewModel
{
    func addFavorites(isFavorite: Bool, article: Article)
    {
        do {
            try service.addFavorites(with: isFavorite, article)
        } catch let error as NSError {
            print(error)
        }
    }
}
