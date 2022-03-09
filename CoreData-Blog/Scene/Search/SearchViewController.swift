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
        searchBar.delegate    = self
        searchBar.placeholder = "Search"
        
        tableView.dataSource  = self
        tableView.delegate    = self
        tableView.register(nibName: K.TableView.searchNibName, cell: K.TableView.searchCell)
    }
}

extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.searchCell, for: indexPath) as! SearchTableViewCell
        cell.configureCell()

        return cell
    }
}

extension SearchViewController: UITableViewDelegate
{
}

extension SearchViewController: UISearchBarDelegate
{
    // MARK: - Text Changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard searchText != "" else { return }
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

