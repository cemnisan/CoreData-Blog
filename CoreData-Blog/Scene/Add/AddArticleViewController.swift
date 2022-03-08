//
//  AddArticleViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import UIKit

// MARK: - Initialize
final class AddArticleViewController: BaseViewController
{
    // MARK: - IBOutlets
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    
    // MARK: - Properties
    var viewModel: AddArticleViewModelProtocol! { didSet { viewModel.delegate = self } }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

// MARK: - IBActions
extension AddArticleViewController
{
    @IBAction private func saveButtonPressed(_ sender: UIBarButtonItem)
    {
        let title   = titleTextField.text!
        let content = contentTextView.text!
        
        viewModel.addArticle(with: title, content: content)
    }
}

// MARK: - AddViewModelDelegate
extension AddArticleViewController: AddArticleViewModelDelegate
{
    func handleOutput(_ output: AddArticleViewModelOutput) {
        switch output {
        case .isAdded(.success(let isAdded)):
            configureIndicatorView(with: isAdded)
        case .isAdded(.failure(let error)):
            self.showError(title: "Error", message: error.localizedDescription)
        }
    }
}

// MARK: - Configure
extension AddArticleViewController
{
    private func configureIndicatorView(with isAdded: Bool)
    {
        if isAdded {
            self.showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            self.hideLoadingView()
        }
    }
}
