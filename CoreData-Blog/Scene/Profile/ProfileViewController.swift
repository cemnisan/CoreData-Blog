//
//  ProfileViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit
import CoreData
// TODO: - Use Diffable Data Source

// MARK: - Initialize
final class ProfileViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet private weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: ProfileViewModelProtocol!
    private var articles: [Article] = []
    private var category = "Software"
    private var dataSource: UITableViewDiffableDataSource<String, Article>!

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
        configureViewModel()
        configureTableView()
    }
    
    private func configureTableView()
    {
        tableView.register(nibName: K.TableView.homeNibName,
                           cell: K.TableView.homeCell)
        dataSource = setupDataSource()
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
            updateDataSource()
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

// MARK: - UITableViewDiffableDataSoruce
extension ProfileViewController
{
    private func setupDataSource() -> UITableViewDiffableDataSource<String, Article>
    {
        UITableViewDiffableDataSource(tableView: tableView) { [weak self] (tableView,
                                                                           indexPath,
                                                                           article) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.homeCell,
                                                     for: indexPath) as! HomeTableViewCell
            cell.configureCell(with: article)
            cell.delegate = self
            cell.isFavorite = article.isFavorite
            cell.id = article.id
            
            return cell
        }
    }
    
    private func updateDataSource()
    {
        var snapshot = NSDiffableDataSourceSnapshot<String, Article>()
        snapshot.appendSections(["favorite"])
        snapshot.appendItems(articles)
       
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
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
        viewModel.removeFavorites(with: id, on: category)
    }
}
