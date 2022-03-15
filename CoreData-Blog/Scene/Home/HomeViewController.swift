//
//  ViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

// MARK: - Initialize HomeViewController
final class HomeViewController: BaseViewController
{
    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: HomeViewModelProtocol!
    private var paginatedArticles: [Article] = []
    private var fetchOffset = 0
    private var currentArticlesCount: Int?
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewModel.removeStoredArticles()
        fetchOffset = 0
        viewModel.loadPaginatedArticles(with: fetchOffset)
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
        tableView.tableFooterView = UIView()
    }
    
    private func configureViewModel()
    {
        viewModel.delegate = self
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
        case .paginatedArticles((let articles, let count)):
            self.paginatedArticles = articles
            self.currentArticlesCount = count
            tableView.reloadData()
        case .showError(let error):
            self.showError(title: "Error", message: error.localizedDescription)
        case .isFavorited((let article, let isFavorite)):
            NotificationBannerManager
                .shared
                .createNotification(with: isFavorite, selectedArticle: article)
        }
    }
    
    func navigate(to route: HomeViewModelRouter)
    {
        switch route {
        case .add(let addViewModel):
            let viewController = AddArticleBuilder.make(viewModel: addViewModel)
            
            show(viewController, sender: nil)
        case .detail(let article,
                     let detailViewModel):
            let viewController = DetailBuilder.make(with: article, detailViewModel)
            
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
        return paginatedArticles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.homeCell,
                                                 for: indexPath) as! HomeTableViewCell
        let article = paginatedArticles[indexPath.row]
        cell.configureCell(with: article)
        cell.delegate = self
        cell.id = article.id
        cell.isFavorite = article.isFavorite

        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        let article = paginatedArticles[indexPath.row]
        
        viewModel.selectedArticle(article: article)
    }
}

// MARK: - UITableViewCell Delegate
extension HomeViewController: IHomeTableViewCell
{
    func bookMarkButtonWillPressed(on cell: HomeTableViewCell,
                                   with id: UUID)
    {
        viewModel.addFavorites(with: id)
    }
}

// MARK: - UIScrollView
extension HomeViewController
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool)
    {
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
     
        if maximumOffset - currentOffset <= 50
        {
            if paginatedArticles.count >= 5 &&
               paginatedArticles.count != currentArticlesCount
            {
                fetchOffset += 5
                viewModel.loadPaginatedArticles(with: fetchOffset)
            }
        }
    }
}
