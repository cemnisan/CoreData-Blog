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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties
    var viewModel: SearchViewModelProtocol!
    private var foundArticles: [Article] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - Configure
extension SearchViewController
{
    private func configureUI()
    {
        searchBar.delegate       = self
        
        tableView.register(nibName: K.TableView.searchNibName,
                           cell: K.TableView.searchCell)
        tableView.dataSource     = self
        tableView.delegate       = self
        tableView.separatorStyle = .none
        
        viewModel.delegate       = self
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
        case .notFound(let error):
            print(error)
        }
    }
    
    func navigate(to router: SearchViewModelRouter) {
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
        return foundArticles.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: K.TableView.searchCell,
                                                    for: indexPath) as! SearchTableViewCell
        let article = foundArticles[indexPath.row]
        
        cell.configureCell(with: article)

        return cell
    }
}

// UITableView Delegate
extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        let article = foundArticles[indexPath.row]
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
        guard searchText != "" else
        {
            foundArticles = []
            tableView.reloadData()
            return
        }
        viewModel.getArticles(with: searchText)
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

