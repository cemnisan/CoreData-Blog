//
//  HomeViewModel.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import Foundation
import CoreData

final class HomeViewModel: HomeViewModelProtocol
{
    weak var delegate: HomeViewModelDelegate?
    private let coreDataService: ICoreDataService
    
    init(coreDataService: ICoreDataService)
    {
        self.coreDataService = coreDataService
    }
}

// MARK: - ViewModel's Protocol
extension HomeViewModel
{
    func load()
    {
        notify(.loading(true))
        
        coreDataService.fetchArticles { [weak self] result in
            guard let self = self else { return }
            self.notify(.loading(false))
           
            switch result {
            case .success(let fetchController):
                self.notify(.showArticlesVia(fetchController))
            case .failure(let error):
                self.notify(.showError(error))
            }
        }
    }
    
    func importJSON()
    {
        coreDataService.importJSONSeedDataIfNeeded()
    }
    
    func selectAddButton() {
        let addViewModel = AddArticleViewModel(service: coreDataService)
        delegate?.navigate(to: .add(addViewModel))
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
