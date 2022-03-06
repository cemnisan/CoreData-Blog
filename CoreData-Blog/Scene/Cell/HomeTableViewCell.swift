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
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var articleContentPic: UIImageView!
    @IBOutlet weak var articleContentLabel: UILabel!
    
    // MARK: - Lifecycles
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        userProfilePic.makeRounded()
    }

    override func setSelected(_ selected: Bool,
                              animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Configure
extension HomeTableViewCell
{
    func configureCell(with article: Article)
    {
        userNameLabel.text = article.author?.userName
        articleContentLabel.text = article.content
    }
}
