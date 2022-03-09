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
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
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
    }
}
