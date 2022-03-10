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
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: HomeViewModelProtocol!
    var articles: [Article] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
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
        configureTableView()
        configureViewModel()
    }
    
    private func configureTableView()
    {
        tableView.register(nibName: K.TableView.homeNibName, cell: K.TableView.homeCell)
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    private func configureViewModel()
    {
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

// MARK: - IBActions
extension HomeViewController
{
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem)
    {
        viewModel.selectAddButton()
    }
}

// MARK: - View Model's Delegate
extension HomeViewController: HomeViewModelDelegate
{
    func handleOutput(_ output: HomeViewModelOutput)
    {
        switch output {
        case .showArticlesVia(let articles):
            self.articles = articles
            tableView.reloadData()
        case .loading(let isLoading):
            configureIndicatorView(with: isLoading)
        case .showError(let error):
            self.showError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func navigate(to route: HomeViewModelRouter)
    {
        switch route {
        case .add(let addViewModel):
            let viewController = AddArticleBuilder.make(viewModel: addViewModel)
            show(viewController, sender: nil)
        case .detail(let article, let viewModel):
            let viewController = DetailBuilder.make(with: article, viewModel)
            show(viewController, sender: nil)
        }
    }
}

// MARK: - UITableView Data-Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.homeCell,
                                                 for: indexPath) as! HomeTableViewCell
        let article = articles[indexPath.row]
        cell.configureCell(with: article)
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        let article = articles[indexPath.row]
        
        viewModel.selectedArticle(article: article)
    }
}
