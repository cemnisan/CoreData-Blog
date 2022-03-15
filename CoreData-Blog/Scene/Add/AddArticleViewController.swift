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
    @IBOutlet private weak var addArticleButton: UIButton!
    @IBOutlet private weak var nowDateTextField: UITextField!
    
    // MARK: - Properties
    var viewModel: AddArticleViewModelProtocol! { didSet { viewModel.delegate = self } }
    private lazy var pickerView = UIPickerView()
    private var category: [String] = ["Swift", "Kotlin", "Javascript", "Go"]
    private var date = Date()
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nowDateTextField.isEnabled = false
        nowDateTextField.text = "\(date.getFormattedDate(format: "MMM d, yyyy"))"
        articleImageView.makeRounded()
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
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true, completion: nil)
    }

    @objc private func pickerViewDoneButtonPressed()
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
        if isAdded
        {
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
                                         action: #selector(pickerViewDoneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        categoryTextField.inputAccessoryView = toolbar
        
        pickerView.delegate   = self
        pickerView.dataSource = self
   
        categoryTextField.inputView = pickerView
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

extension AddArticleViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController
                            .InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        {
            articleImageView.image = image
            addArticleButton.setTitle("+ Change article's photo",
                                      for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddArticleViewController: UINavigationControllerDelegate { }
