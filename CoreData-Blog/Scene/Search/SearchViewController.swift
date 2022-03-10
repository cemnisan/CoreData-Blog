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
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    // MARK: - Properties
    var viewModel: SearchViewModelProtocol!
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
        
        fetchArticles(with: category)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        configureSearch()
    }
}

// MARK: - IBActions
extension SearchViewController
{
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl)
    {
        guard let category = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
        self.category = category
        
        let selectCategory = SelectCategory.selectSegmentControl(with: category)
        let selectedCategory = selectCategory.category
        
        fetchArticles(with: selectedCategory)
    }
    
    private func fetchArticles(with selectedCategory: String)
    {
        viewModel.getArticles(category: selectedCategory)
    }
}

// MARK: - Configure
extension SearchViewController
{
    private func configureUI()
    {
        configureViewModel()
        configureTableView()
        configureSearchBar()
    }
    
    private func configureTableView()
    {
        tableView.register(nibName: K.TableView.searchNibName, cell: K.TableView.searchCell)
        tableView.dataSource     = self
        tableView.delegate       = self
        tableView.separatorStyle = .none
    }
    
    private func configureViewModel()
    {
        viewModel.delegate = self
    }
    
    private func configureSearchBar()
    {
        searchBar.delegate = self
    }
    
    private func configureSearch()
    {
        searchBar.text = ""
        foundArticles  = []
        tableView.reloadData()
    }
    
    private func configureResult()
    {
        if searchBar.text!.isEmpty {
            fetchArticles(with: category)
            tableView.reloadData()
        } else if foundArticles.count == 0 ||
                  foundArticles.count > 0
        {
            foundArticlesWithCategory = []
            tableView.reloadData()
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
        if foundArticles.count > 0 {
            return foundArticles.count
        } else {
            return foundArticlesWithCategory.count
        }
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

// MARK: - UISearchBar Delegate
extension SearchViewController: UISearchBarDelegate
{
    // MARK: - Text Changes
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String)
    {
        viewModel.getArticles(with: searchText, category)
        configureResult()
    }
    
    // MARK: - Search Button Pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        guard let searchText = searchBar.text, searchText != "" else
        {
            searchBar.placeholder = "Look for something..."
            return
        }
        searchBar.placeholder = "Search"
    }
}

// MARK: - Helpers
extension SearchViewController
{
    private func selectedArticle(at indexPath: IndexPath) -> Article
    {
        var article: Article?
        
        if foundArticles.count > 0 {
            article = foundArticles[indexPath.row]
        } else {
            article = foundArticlesWithCategory[indexPath.row]
        }
        
        return article!
    }
}
