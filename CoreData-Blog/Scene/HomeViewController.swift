//
//  ViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class HomeViewController: UIViewController
{
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewModel.load()
    }
}

extension HomeViewController: HomeViewModelDelegate
{
    func handleOutput(_ output: HomeViewModelOutput)
    {
        print(output)
    }
}

