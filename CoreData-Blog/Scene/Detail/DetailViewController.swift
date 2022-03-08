//
//  DetailViewController.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import UIKit
import CoreData


// MARK: - Initialize
final class DetailViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet private weak var userPhotoView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleDateLabel: UILabel!
    @IBOutlet private weak var articleSaveButton: UIButton!
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var articleContentPhoto: UIImageView!
    @IBOutlet private weak var articleContentLabel: UILabel!
    
    // MARK: - Properties
    var article: Article?
    var viewModel: DetailViewModelProtocol!
    private var isFavorite: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - Configure
extension DetailViewController
{
    private func configureUI()
    {
        userPhotoView.makeRoundedCircle()
        articleContentPhoto.makeRounded()
        
        title                    = article?.title
        userNameLabel.text       = article?.author?.userName
        articleDateLabel.text    = article?.createdDate?.getFormattedDate(format: "MMM d, yyyy")
        articleTitleLabel.text   = article?.title
        articleContentLabel.text = article?.content
        isFavorite               = article?.isFavorite ?? false
        
        configureBookMark(with: isFavorite)
    }
    
    private func configureBookMark(with isSaved: Bool)
    {
        isSaved ? selectBookMark(.bookMarkFill) : selectBookMark(.bookMark)
    }
}

// MARK: - IBActions
extension DetailViewController
{
    @IBAction private func saveButtonPressed(_ sender: UIButton)
    {
        isFavorite = !isFavorite
        configureBookMark(with: isFavorite)
        viewModel.addFavorites(isFavorite: isFavorite, article: article!)
    }
}

// MARK: - Helpers
extension DetailViewController
{
    private func selectBookMark(_ bookMark: SelectBookMark)
    {
        switch bookMark {
        case .bookMark:
            articleSaveButton.setBackgroundImage(UIImage(systemName: bookMark.selectedBookMark),
                                                 for: .normal)
        case .bookMarkFill:
            articleSaveButton.setBackgroundImage(UIImage(systemName: bookMark.selectedBookMark),
                                                 for: .normal)
        }
    }
}
