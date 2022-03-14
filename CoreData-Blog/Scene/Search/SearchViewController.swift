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
    @IBOutlet private weak var recommendOrResultLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: SearchViewModelProtocol!
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private var foundArticles: [Article] = []
    private var foundArticlesWithCategory: [Article] = []
    private var category = "Software"
    private var fetchOffset = 0
    private var currentArticlesCountByCategory = 0
    private var currentArticlesCountByQuery = 0
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        fetchOffset = 0
        viewModel.removeStoredArticles()
        configureSearchBar()
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
        title = "Explore"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "Search Article"
        searchController.searchResultsUpdater  = self
        searchController.searchBar.delegate    = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = SelectCategory.allCases.map { $0.rawValue }
    }
    
    private func configureSearchBar()
    {
        searchController.isActive = false
    }
    
    private func configureResult()
    {
        if searchController.isSearching
        {
            fetchOffset = 0
            viewModel.removeStoredArticles()
            viewModel.getArticles(with: searchController.searchBar.text!, category, fetchOffset: fetchOffset)
        }
        else if searchController.isSearchBarEmpty &&
                searchController.isActive
        {
            viewModel.removeStoredArticles()
            foundArticlesWithCategory.removeAll()
            currentArticlesCountByCategory = 0
            recommendOrResultLabel.text = ""
            tableView.reloadData()
        }
        else
        {
            fetchOffset = 0
            viewModel.removeStoredArticles()
            foundArticles.removeAll()
            currentArticlesCountByQuery = 0
            viewModel.getArticles(with: category, fetchOffset: fetchOffset)
        }
    }
}

// MARK: - ViewModel Delegate
extension SearchViewController: SearchViewModelDelegate
{
    func handleOutput(_ output: SearchViewModelOutput)
    {
        switch output {
        case .foundArticles((let articles, let currentArticlesCount)):
            self.foundArticles = articles
            self.currentArticlesCountByQuery = currentArticlesCount
            
            let resultText = "\(self.currentArticlesCountByQuery) Results for `\(searchController.searchBar.text!)` in \(category) Category"
            self.recommendOrResultLabel.text = resultText
            self.tableView.reloadData()
            
        case .foundArticlesWithCategory((let articles, let currentArticlesCount)):
            self.foundArticlesWithCategory = articles
            self.currentArticlesCountByCategory = currentArticlesCount
            
            self.recommendOrResultLabel.text = "Recommend for you"
            tableView.reloadData()
            
        case .showError(let error):
            print(error)
        case .isFavorited(let isFavorite):
            print(isFavorite)
        }
    }
    
    func navigate(to router: SearchViewModelRouter)
    {
        switch router {
        case .detail(let article,
                     let viewModel):
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
        cell.delegate = self
        cell.id = article.id
        cell.isFavorite = article.isFavorite
        
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

// MARK: - TableViewCell Delegate
extension SearchViewController: ISearchTableViewCell
{
    func bookMarkButtonWillPressed(on vc: SearchTableViewCell,
                                   with id: UUID)
    {
        viewModel.addFavorites(with: id)
    }
}

// MARK: - UIScrollView
extension SearchViewController
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool)
    {
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 0
        {
            if searchController.isSearching,
               foundArticles.count >= 6 &&
               foundArticles.count != currentArticlesCountByQuery
            {
                fetchOffset += 6
                viewModel.getArticles(with: searchController.searchBar.text!, category, fetchOffset: fetchOffset)
            } else {
                if foundArticlesWithCategory.count >= 6 &&
                   foundArticlesWithCategory.count != currentArticlesCountByCategory
                {
                    fetchOffset += 6
                    viewModel.getArticles(with: category, fetchOffset: fetchOffset)
                }
            }
        }
    }
}

// MARK: - SearchController Result Update
extension SearchViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
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
        
        if foundArticles.count > 0
        {
            article = foundArticles[indexPath.row]
        } else {
            article = foundArticlesWithCategory[indexPath.row]
        }
        
        return article
    }
}
