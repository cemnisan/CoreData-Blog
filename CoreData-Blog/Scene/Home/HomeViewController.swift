//
//  ViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit
import CoreData

// MARK: - Initialize HomeViewController
final class HomeViewController: BaseViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: HomeViewModelProtocol!
    var fetchedResultsController: NSFetchedResultsController<Article>?
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
        viewModel.importJSON()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewModel.load()
    }
}

// MARK: - Configure
extension HomeViewController
{
    private func configureUI()
    {
        tableView.dataSource = self
        tableView.register(nibName: K.TableView.homeNibName,
                           cell: K.TableView.homeCell)
        
        viewModel.delegate = self
    }
    
    private func configureIndicatorView(with isLoading: Bool)
    {
        if isLoading {
            self.showLoadingView()
            tableView.separatorStyle = .none
        } else {
            self.hideLoadingView()
            tableView.separatorStyle = .singleLine
        }
    }
}

// MARK: - View Model's Delegate
extension HomeViewController: HomeViewModelDelegate
{
    func handleOutput(_ output: HomeViewModelOutput)
    {
        switch output {
        case .showArticlesVia(let fetchedResultsController):
            self.fetchedResultsController = fetchedResultsController
        case .loading(let isLoading):
            configureIndicatorView(with: isLoading)
        case .showError(let error):
            self.showError(title: "Error", message: error.localizedDescription)
        }
    }
}

// MARK: - UITableView Data-Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.homeCell,
                                                 for: indexPath) as! HomeTableViewCell
        let article = fetchedResultsController?.object(at: indexPath)
        cell.configureCell(with: article!)
        
        return cell
    }
}
