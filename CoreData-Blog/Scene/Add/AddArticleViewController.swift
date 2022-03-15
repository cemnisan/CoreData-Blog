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
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var categoryTextField: UITextField!
    
    // MARK: - Properties
    var viewModel: AddArticleViewModelProtocol! { didSet { viewModel.delegate = self } }
    private lazy var pickerView = UIPickerView()
    private var category: [String] = ["Swift", "Kotlin", "Javascript", "Go"]
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureToolBar()
    }
}

// MARK: - IBActions
extension AddArticleViewController
{
    @IBAction private func saveButtonPressed(_ sender: UIBarButtonItem)
    {
        
        guard let title    = titleTextField.text,
              let content  = contentTextView.text,
              let category = categoryTextField.text,
              let image    = articleImageView.image else { return }
        
        viewModel.addArticle(with: title,
                             content: content,
                             image: image,
                             category: category)
    }
    
    @IBAction private func choosePhotoButtonPressed(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }

    @objc private func doneButtonPressed()
    {
        let selectedValue = category[pickerView.selectedRow(inComponent: 0)]
        categoryTextField.text = selectedValue
        
        self.view.endEditing(true)
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
    
    private func configureToolBar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        categoryTextField.inputAccessoryView = toolbar
        
        pickerView.delegate   = self
        pickerView.dataSource = self
   
        categoryTextField.inputView = pickerView
    }
}

// MARK: - UIPickerView DataSource
extension AddArticleViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int
    {
        return category.count
    }
}

// MARK: - UIPickerView Delegate
extension AddArticleViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String?
    {
        return category[row]
    }
}


// MARK: - AddViewModelDelegate
extension AddArticleViewController: AddArticleViewModelDelegate
{
    func handleOutput(_ output: AddArticleViewModelOutput)
    {
        switch output {
        case .isAdded(.success(let isAdded)):
            configureIndicatorView(with: isAdded)
        case .isAdded(.failure(let error)):
            self.showError(title: "Error", message: error.localizedDescription)
        }
    }
}

extension AddArticleViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[UIImagePickerController
                                .InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else { return }
        articleImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddArticleViewController: UINavigationControllerDelegate { }
