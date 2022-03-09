//
//  SearchTableViewCell.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 9.03.2022.
//

import UIKit

// MARK: - Initialize
final class SearchTableViewCell: UITableViewCell
{
    // MARK: - IBOutlets
    @IBOutlet private weak var userProfilePhoto: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePhoto.makeRoundedCircle()
    }
}

// MARK: - Configure
extension SearchTableViewCell
{
    func configureCell(with article: Article)
    {
        userNameLabel.text     = article.author?.userName
        articleTitleLabel.text = article.title
        
        article.isFavorite ?
            bookMarkButton.setBookMark(bookMark: .bookMarkFill) :
            bookMarkButton.setBookMark(bookMark: .bookMark)
    }
}
