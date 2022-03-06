//
//  ViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class HomeViewController: UIViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    // MARK: - Properties
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var articles: [Article] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        registerTableView()
        viewModel.importJSONSeedDataIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewModel.fetchArticles()
    }
}

// MARK: - Configure
extension HomeViewController
{
    private func registerTableView()
    {
        tableView.register(
            UINib(nibName: "HomeTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HomeCell")
    }
}

// MARK: - View Model Delegate
extension HomeViewController: HomeViewModelDelegate
{
    func handleOutput(_ output: HomeViewModelOutput)
    {
        switch output {
        case .showArticle(let articles):
            self.articles = articles
            tableView.reloadData()
        case .loading(let isLoading):
            print(isLoading)
        }
    }
}

// MARK: - UITableView Data-Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        articles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell",
                                                 for: indexPath) as! HomeTableViewCell
        let article = articles[indexPath.row]
        cell.configureCell(with: article)
        
        return cell
    }
}
