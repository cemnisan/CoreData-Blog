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
    private var isTouched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPhotoView.makeRoundedCircle()
        articleContentPhoto.makeRounded()
        configureUI()
    }
}

// MARK: - Configure
extension DetailViewController
{
    private func configureUI()
    {
        title                    = article?.title
        userNameLabel.text       = article?.author?.userName
        articleDateLabel.text    = article?.createdDate?.getFormattedDate(format: "MMM d, yyyy")
        articleTitleLabel.text   = article?.title
        articleContentLabel.text = article?.content
    }
}

// MARK: - IBActions
@available(iOS 13.0, *)
extension DetailViewController
{
    @IBAction private func saveButtonPressed(_ sender: UIButton)
    {
        isTouched = !isTouched
        
        isTouched ? selectBookMark(.bookMarkFill) : selectBookMark(.bookMark)
    }
    
    private func selectBookMark(_ bookMark: SelectBookMark) {
        if bookMark == .bookMarkFill {
            articleSaveButton.setBackgroundImage(UIImage(systemName: bookMark.selectedBookMark), for: .normal)
        } else {
            articleSaveButton.setBackgroundImage(UIImage(systemName: bookMark.selectedBookMark), for: .normal)
        }
    }
}
