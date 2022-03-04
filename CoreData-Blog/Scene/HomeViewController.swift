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
    
    // MARK: - Lifecycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        registerTableView()
        viewModel.load()
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
        print(output)
    }
}

// MARK: - UITableView Data-Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell",
                                                 for: indexPath) as! HomeTableViewCell
        return cell
    }
}
