//
//  ProfileViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

// TODO: - Use Diffable Data Source

// MARK: - Initialize
final class ProfileViewController: UIViewController
{
    // MARK: - IBOuetlets
    @IBOutlet private weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: ProfileViewModelProtocol!
    private var articles: [Article] = []
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
        
        viewModel.getFavoriteArticles(with: category)
    }
}

// MARK: - Configure
extension ProfileViewController
{
    private func configureUI()
    {
        configureTableView()
        configureViewModel()
    }
    
    private func configureTableView()
    {
        tableView.register(nibName: K.TableView.homeNibName, cell: K.TableView.homeCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func configureViewModel()
    {
        viewModel.delegate = self
    }
}

// MARK: - IBActions
extension ProfileViewController
{
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl)
    {
        guard let category = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
        viewModel.getFavoriteArticles(with: category)
    }
}

// MARK: - ViewModel Delegate
extension ProfileViewController: ProfileViewModelDelegate
{
    func handleOutput(_ output: ProfileViewModelOutput)
    {
        switch output {
        case .favoriteArticles(let articles):
            self.articles = articles
            tableView.reloadData()
        case .error(let error):
            print(error)
        case .isFavorited(.success(let isFavorited)):
            print(isFavorited)
        case .isFavorited(.failure(let error)):
            print(error)
        }
    }
    
    func navigate(to router: ProfileViewModelRouter)
    {
        switch router {
        case .detail(let detailViewModel, let article):
            let viewController = DetailBuilder.make(with: article, detailViewModel)
            show(viewController, sender: nil)
        }
    }
}

// MARK: - UITableView Data-Source
extension ProfileViewController: UITableViewDataSource
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
        cell.delegate = self
        cell.id = article.id
        cell.isFavorite = article.isFavorite
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        viewModel.selectedArticle(article: article)
    }
}

// MARK: - TableViewCell Delegate
extension ProfileViewController: IHomeTableViewCell
{
    func bookMarkButtonWillPressed(on cell: HomeTableViewCell,
                                   with id: UUID)
    {
        viewModel.addFavorites(with: id)
    }
}
