//
//  SearchViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

// MARK: - Initialize
final class SearchViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: SearchViewModelProtocol!
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private var foundArticles: [Article] = []
    private var foundArticlesWithCategory: [Article] = []
    private var category = "Software"

    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
 
        viewModel.getArticles(category: category)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        configureSearch()
    }
}

// MARK: - Configure
extension SearchViewController
{
    private func configureUI()
    {
        configureTableView()
        configureViewModel()
        configureSearchController()
    }
    
    private func configureTableView()
    {
        tableView.register(nibName: K.TableView.searchNibName, cell: K.TableView.searchCell)
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.separatorStyle  = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    private func configureViewModel()
    {
        viewModel.delegate = self
    }
    
    private func configureSearchController()
    {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate   = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = SelectCategory.allCases.map { $0.rawValue }
    }
    
    private func configureSearch()
    {
        searchController.searchBar.text = ""
        foundArticles = []
    }
    
    private func configureResult()
    {
        if searchController.isSearching {
            foundArticlesWithCategory = []
            tableView.reloadData()
        } else {
            viewModel.getArticles(category: category)
        }
    }
}

// MARK: - ViewModel Delegate
extension SearchViewController: SearchViewModelDelegate
{
    func handleOutput(_ output: SearchViewModelOutput)
    {
        switch output {
        case .foundArticles(let articles):
            self.foundArticles = articles
            tableView.reloadData()
        case .foundArticlesWithCategory(let articles):
            self.foundArticlesWithCategory = articles
            tableView.reloadData()
        case .notFound(let error):
            print(error)
        }
    }
    
    func navigate(to router: SearchViewModelRouter)
    {
        switch router {
        case .detail(let article, let viewModel):
            let detailViewController = DetailBuilder.make(with: article, viewModel)
            show(detailViewController, sender: nil)
        }
    }
}

// MARK: - UITableView Data Source
extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        if searchController.isSearching { return foundArticles.count }
        
        return foundArticlesWithCategory.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.searchCell,
                                                    for: indexPath) as! SearchTableViewCell
        let article = selectedArticle(at: indexPath)
        cell.configureCell(with: article)

        return cell
    }
}

// MARK: - UITableView Delegate
extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        let article = selectedArticle(at: indexPath)
        viewModel.selectedArticle(article: article)
    }
}

// MARK: - SearchController Result Update
extension SearchViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        viewModel.getArticles(with: searchController.searchBar.text!, category)
        configureResult()
    }
}

// MARK: - SearchController SearchBar Delegate
extension SearchViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        let selecetedCategory = SelectCategory(rawValue: searchBar.scopeButtonTitles![selectedScope])
        category = selecetedCategory!.rawValue
    }
}

// MARK: - Helpers
extension SearchViewController
{
    private func selectedArticle(at indexPath: IndexPath) -> Article
    {
        let article: Article
        
        if foundArticles.count > 0 {
            article = foundArticles[indexPath.row]
        } else {
            article = foundArticlesWithCategory[indexPath.row]
        }
        
        return article
    }
}
