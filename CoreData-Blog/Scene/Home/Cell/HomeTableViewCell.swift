//
//  HomeTableViewCell.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//

import UIKit

final class HomeTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    @IBOutlet private weak var userProfilePic: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleContentPic: UIImageView!
    @IBOutlet private weak var articleContentLabel: UILabel!
    @IBOutlet private weak var articleDateTextField: UILabel!
    @IBOutlet private weak var articleTitleTextField: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    
    // MARK: - Lifecycles
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePic.makeRoundedCircle()
        articleContentPic.makeRounded()
    }
}

// MARK: - Configure
extension HomeTableViewCell
{
    func configureCell(with article: Article)
    {
        userNameLabel.text         = article.author?.userName
        articleTitleTextField.text = article.title
        articleContentLabel.text   = article.content
        articleDateTextField.text  = article.createdDate?.getFormattedDate(format: "MMM d, yyyy")
        
        bookMarkConfigure(isFavorited: article.isFavorite)
    }
    
    private func bookMarkConfigure(isFavorited: Bool)
    {
        isFavorited ?
            bookMarkButton.setBookMark(bookMark: .bookMarkFill) :
            bookMarkButton.setBookMark(bookMark: .bookMark)
    }
}
